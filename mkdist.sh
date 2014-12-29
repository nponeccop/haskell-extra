cabal update
cblrepo sync
cblrepo updates
sudo pacman -Sy
pacman -Sl haskell-{core,happstack} | cut -d ' ' -f 2,3 >distpkg

