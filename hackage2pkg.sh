while read FOO
do
	name=$(echo $FOO | tr '[:upper:]' '[:lower:]')
	hprefix=$([[ -d haskell-$name ]] && echo haskell-)
	echo "$hprefix$name"
done
