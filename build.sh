set -ex
PKG=$(echo $1 | tr '[:upper:]' '[:lower:]')
cblrepo pkgbuild $1 --ghc-version 7.8.4
cd haskell-$PKG
makepkg -sci --needed --asdeps -L 
mkaurball
mv *.src.tar.gz ../aur/

