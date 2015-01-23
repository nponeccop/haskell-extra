set -e
PKG=$(echo $1 | tr '[:upper:]' '[:lower:]')
echo "Building haskell-$PKG ($1)"
make cblrepo-pkgbuild-$1
cd haskell-$PKG

makepkg -sc --needed --asdeps --noconfirm || true
yaourt -U --noconfirm --needed $(bash -c '. PKGBUILD; echo $pkgname-$pkgver-$pkgrel-i686.pkg.tar.xz')

#mkaurball
#mv *.src.tar.gz ../aur/

