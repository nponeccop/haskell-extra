set -e
PKG=$(echo $1 | tr '[:upper:]' '[:lower:]')
echo Building $PKG
cblrepo pkgbuild $1 --ghc-version 7.8.4
cd haskell-$PKG
makepkg -sc --needed --asdeps --noconfirm
yaourt -U --noconfirm $(ls -1v *.pkg.tar.xz | tail -n 1)
mkaurball
mv *.src.tar.gz ../aur/

