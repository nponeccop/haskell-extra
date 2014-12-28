SHELL=/bin/bash
MAKEDEPEND.package=bash pkgdepend.sh
COMPILE.package=echo 911 $1


cblrepo-add-%:
	bash madd.sh $*	

cblrepo-pkgbuild-%: cblrepo-add-%
	cblrepo pkgbuild --ghc-version=7.8.4 $*
	$(MAKEDEPEND.package) $* >P/$*.P

%.src.tar.xz: %.pkg.tar.xz
	cd $(<D) && mkaurball && cp $@ ../aur

%.pkg.tar.xz:
	pacman -Q $(@D) || (cd $(@D) && makepkg -sci)
	
%/PKGBUILD: cblrepo.db
-include P/*.P
