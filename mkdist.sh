cabal update
cblrepo sync
cblrepo updates
sudo pacman -Sy
pacman -Sl haskell-{core,happstack} | grep "^has" >distpkg 
