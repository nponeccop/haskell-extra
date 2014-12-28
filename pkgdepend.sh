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
echo 2>"Dependencies for $1"
for i in $(pkgbuild_deps $path)
do
	[[ -r upstream/$i ]] && dep+=" upstream/$i" || dep+=" $i"
done
nv=$name-$(pkgbuild_version $path/PKGBUILD)
pkg=$path/$nv.pkg.tar.xz
cat <<EEE
$path:$dep
$pkg: $path/PKGBUILD
aur/%.src.tar.gz: $path/%.pkg.tar.xz
	cp \$(<) \$(@)
$path/PKGBUILD: $(find patches -name \'$hkgname.*\') cblrepo.db
$path: $path/$nv.pkg.tar.xz
EEE
