set -ex
PKG=$(echo $1 | tr '[:upper:]' '[:lower:]')
cblrepo pkgbuild $1 --ghc-version 7.8.4
cd haskell-$PKG
makepkg -sc --needed --asdeps -L 
yaourt -U $(ls -1v *.pkg.tar.xz | tail -n 1)
mkaurball
mv *.src.tar.gz ../aur/

