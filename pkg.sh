quilt new $1.pkgbuild
cd haskell-$(echo $1 | tr [:upper:] [:lower:])
quilt add PKGBUILD
vim PKGBUILD
quilt refresh
cd ..
bash build.sh $1
