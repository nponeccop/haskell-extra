echo "Adding $1"

cblrepo add $1 \
	| awk '$1 != "Failed" && $1 != "" {print "haskell-" tolower($1)}' \
	| xargs --no-run-if-empty pacman -Q 2>xx >yy
echo Distribution packages:
cat yy
echo Grepping
cat yy \
	| perl -pe 's/haskell-(.+) (.+)-(.+)/-d $1,$2,$3/o' \
	| xargs --no-run-if-empty cblrepo add 
echo haskell packages
cat xx
echo grepping
cat xx \
	| perl -pe 's/error: package \Whaskell-(.*?)\W was not found/$1/o' \
	| xargs --no-run-if-empty -l ghc-pkg list --simple-output 2>/dev/null \
	| perl -pe 's/(.*)-(.*)/-g $1,$2/o' \
	| xargs --no-run-if-empty cblrepo add 
echo adding
cblrepo add $1 | tee zz
cat zz | awk '/^ / {print $1}' | xargs -l --no-run-if-empty bash auto.sh
