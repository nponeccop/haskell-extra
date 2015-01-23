set -ex
grep -o "$1=[0-9.-]*" patches/*.pkgbuild | cut -d '=' -f 2 | sort | uniq
newver=$(cblrepo list -d $2 | cut -d ' ' -f 3)
[ -z "$newver" ] && echo "no $2 in cblrepo" && exit
sed -i "s|$1=[0-9.-]*|$1=${newver}|g" patches/*.pkgbuild
