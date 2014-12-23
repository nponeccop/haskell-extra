cabal install $1 --dry-run | grep -i $1 | tail -n 1 | perl -pe 's/(.*)-(.*)/$1,$2/o'

