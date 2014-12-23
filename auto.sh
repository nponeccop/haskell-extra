PACKERLIB=1 
. ./packerlib
LO=haskell-$(echo $1 | tr '[:upper:]' '[:lower:]')

[[ -d $LO ]] && echo $LO is already built && exit

(existsinpacman $LO || providedinpacman $LO) && echo "$LO exists in repo" && exit

(bash version.sh $1 | xargs bash add.sh) && bash build.sh $1
