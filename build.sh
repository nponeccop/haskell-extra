echo building $1
LO=$(echo $1 | tr '[:upper:]' '[:lower:]')
cblrepo list $1
cblrepo pkgbuild $1
cd haskell-$LO && makepkg -c && mkaurball
yaourt -U $(ls -1v *.pkg.tar.xz | tail -n 1)
