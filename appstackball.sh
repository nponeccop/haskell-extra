set -x
pushd upstream-repos/haskell-happstack
cblrepo pkgbuild --ghc-version=7.8.4 $1
cd haskell-$(echo $1 | tr '[:upper:]' '[:lower:]')
mkaurball
mv *.src.tar.gz ../../../aur/
popd
