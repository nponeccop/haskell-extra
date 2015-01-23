set -ex
cabal unpack $1 --pristine
quilt new $1.cabal
quilt edit $1-*/$1.cabal
quilt refresh

