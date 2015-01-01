pushd upstream-repos/haskell-core
cblrepo pkgbuild --ghc-version=7.8.4 $1
cd haskell-$(echo $1 | tr '[:upper:]' '[:lower]')
mkaurball -f
mv *.src.tar.gz ../../../aur/
popd
