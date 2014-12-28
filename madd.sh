set -e -o pipefail
[[ -f "upstream/$(echo $ | tr '[:upper:]' '[:lower:]')" ]] && exit 1
grep ^.\"$1\" cblrepo.db >/dev/null \
	|| cblrepo add $(cblrepo versions -l $1)
