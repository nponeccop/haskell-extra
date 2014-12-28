SHELL=/bin/bash
MAKEDEPEND.package=bash pkgdepend.sh
COMPILE.package=echo 911 $1
-include P/*.P
.PHONY: haskell-% upstream-%
haskell-%:  

upstream-%: upstream/%
#	pacman -Q $* || pacman -S $*

%.pkg.tar.xz: $(@D)
	cd $(@D)
	makepkg

cblrepo-add-%:
	bash madd.sh $*	

cblrepo-pkgbuild-%: 
	cblrepo pkgbuild --ghc-version=7.8.4 $*
	$(MAKEDEPEND.package) $* >P/$*.P
%.src.tar.xz: %.pkg.tar.xz
	cd $(<D) && mkaurball

%.pkg.tar.xz: 
	pacman -Q $(@D) || (cd $(@D) && makepkg -sci)

	
%/PKGBUILD: cblrepo.db

haskell-%: haskell-%/PKGBUILD
