const builtin = @import("builtin");
const std = @import("std");
const CrossTarget = std.Target.Query;

// Usage:
//   zig build -Doptimize=<optimization level> -Dtarget=<target> -Dgui=<bool>
// Supported targets:
//   x86-windows-gnu
//   x86-windows-msvc
//   x86_64-windows-gnu
//   x86_64-windows-msvc
//   aarch64-windows-gnu
//   aarch64-windows-msvc

const required_version = std.SemanticVersion.parse("0.14.0") catch unreachable;
const compatible = builtin.zig_version.order(required_version) != .lt;

pub fn build(b: *std.Build) void {
    if (!compatible) {
        std.log.err("Unsupported Zig compiler version", .{});
        return;
    }

    const options = b.addOptions();
    const gui = b.option(bool, "gui", "Build a GUI launcher") orelse false;
    options.addOption(bool, "gui", gui);

    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{ .default_target = CrossTarget{
        .os_tag = .windows,
        .abi = .gnu,
    } });

    if (target.result.os.tag != .windows) {
        std.log.err("Non-Windows target is not supported", .{});
        return;
    }

    const exe_type = if (gui) "gui" else "cli";
    const name = switch (target.result.cpu.arch) {
        .x86 => exe_type ++ "-32",
        .x86_64 => exe_type ++ "-64",
        .aarch64 => exe_type ++ "-arm64",
        else => {
            std.log.err("Unsupported CPU architecture", .{});
            return;
        },
    };

    const exe = b.addExecutable(.{
        .name = name,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
        .win32_manifest = b.path("./launcher.manifest"),
    });

    exe.addCSourceFile(.{ .file = b.path("./launcher.c") });
    exe.root_module.addCMacro("SCRIPT_WRAPPER", "");
    exe.linkLibC();
    exe.subsystem = if (gui) .Windows else .Console;

    if (gui) {
        exe.root_module.addCMacro("_WINDOWS", "");
    }

    if (target.result.abi == .gnu) {
        // NOTE: This requires Zig version 0.12.0-dev.3493+3661133f9 or later
        exe.mingw_unicode_entry_point = true;
    } else {
        exe.linkSystemLibrary("advapi32");
        exe.linkSystemLibrary("shell32");
        if (gui) {
            exe.linkSystemLibrary("user32");
        }
    }

    b.installArtifact(exe);
}
