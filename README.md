# haskell-extra

This is a [cblrepo] repository with about 300 Haskell packages
not found in [haskell-core] or [haskell-happstack] repositories.

The repository is built on top of both `haskell-core` and `haskell-happstack` the same 
way as `haskell-happstack` is built on top of `haskell-core`. So to built the packages
you need these 2 binary repos added to `pacman.conf`.

There is no binaries yet, as I don't have resources to host 
the binary repo and to build x64 versions of packages. All packages
in the repo are privately built only for `i686` ArchLinux before 
each update to detect breakage.

I'm also hesitant to use the existing chroot-based clean build system and 
linear `cblrepo build` ordering. Instead, I try to design a 
`make (1)`-based system with clean builds implemented by [Docker] and support 
for `-j N` parallel builds, with little success so far.

[cblrepo]: https://github.com/magthe/cblrepo
[haskell-core]: https://github.com/archhaskell/habs
[haskell-happstack]: https://github.com/tensor5/haskell-happstack
[Docker]: https://www.docker.com/
