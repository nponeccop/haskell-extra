source abs-builder/framework/src/framework || exit 1
load_package pkgbuild

function tolower()
{
	echo $1 | tr '[:upper:]' '[:lower:]'
}
name=$(tolower $1)
path=haskell-$name
hkgname=$1
set -e
echo "Dependencies for $1" >2
for i in $(pkgbuild_deps $path)
do
	[[ -r upstream/$i ]] && dep+=" upstream/$i" || dep+=" $i"
done
pbnv=haskell-$name-$(pkgbuild_version $path/PKGBUILD)
nv=haskell-$(tolower $(cblrepo list $1 | sed 's|  |-|'))
[[ "$nv" == "$pbnv" ]] || (echo >2 "inconsistent versions: PKGBUILD has $pbnv while cblrepo.db has $nv" ; exit 1)
pkg=$path/$nv-i686.pkg.tar.xz
cat <<EEE
.PHONY: $path hackage-$1
$path:$dep
$path/PKGBUILD: $(find patches -name \'$hkgname.*\')
$path: $pkg
$pkg: $path/PKGBUILD
hackage-$1: $path
pacman-U-$1: $pkg
EEE
