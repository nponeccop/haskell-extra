PACKERLIB=1 
. ./packerlib
LO=haskell-$(echo $1 | tr '[:upper:]' '[:lower:]')

[[ -d $LO ]] && echo $LO is already built && exit

(existsinpacman $LO || providedinpacman $LO) && echo "$LO exists in repo" && (pacman -Siq $LO | grep Ver) && exit

bash add.sh $(bash version.sh $1) && bash build.sh $1
