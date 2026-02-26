# conda-recipes

> Recipes of my conda forge [channel]

## Getting Started

Find and install packages from the channel:

```
pixi search <package> -c chaweyhsu
pixi global install <package> -c chawyehsu -c conda-forge
```

## Development

[Pixi] is used for project mangement.

```
pixi install
pixi run build --recipe-dir <package_dir>
```

## License

**conda-recipes** © [Chawye Hsu](https://github.com/chawyehsu). Released under the [BSD-3-Clause](LICENSE) license.

> [Blog](https://chawyehsu.com) · GitHub [@chawyehsu](https://github.com/chawyehsu) · Twitter [@chawyehsu](https://twitter.com/chawyehsu)

[channel]: https://anaconda.org/chawyehsu/repo
[Pixi]: https://pixi.sh
