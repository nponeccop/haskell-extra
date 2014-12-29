set -e -o pipefail
echo $1
[[ haskell-$1/*.pkg.tar.xz ]] && yaourt -U --noconfirm --needed $(ls -1v haskell-$1/*.pkg.tar.xz | tail -n 1)

