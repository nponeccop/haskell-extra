cabal update
cblrepo sync
cblrepo updates | grep -Fxvf blacklist | tr -d ':()' | tr ' ' '\t' | column -t
sudo pacman -Sy
pacman -Sl haskell-{core,happstack} | cut -d ' ' -f 2,3 >distpkg

