SHELL=/bin/bash
MAKEDEPEND.package=bash pkgdepend.sh
COMPILE.package=echo 911 $1

upstream-cache:
	yaourt -Sy
	([[ -d upstream ]] && rm -r upstream) || true
	mkdir upstream
	cd upstream && pacman -Slq haskell-{core,happstack} | xargs touch
	cd upstream && pacman -Slq community extra | grep -v haskell | xargs touch

clean-unpacked:
	ls -1 | grep '\-[0-9]' | xargs rm -rf

clean-adopted: 
	cblrepo list -g -d --no-repo | grep -iFf <(ls -d haskell-* -1 | sed 's|^haskell-||g') | cut -d ' ' -f 1 | sed 's|^|haskell-|g' | tr '[:upper:]' '[:lower:]' | xargs rm -r


aurball-%:
	cd $* && mkaurball && mv *.src.tar.gz ../aur

.PHONY: aurhaskell
aurhaskell:
	package-query -As haskell- -f "%n\t%L\t%V\t%w\t%o\t%i\t%m\t%U" | tee aurhaskell | column -t

aurrepo:
	join  <(cblrepo list | awk 'BEGIN {OFS="\t"}; {print "haskell-" tolower($1), $2}' | sort) <(cat aurhaskell | cut -f 1,3,7 | sort) | awk '$4 != "zoidberg_md" {print}' | column -t

build-%:
	bash build.sh $*

sync:
	bash sync.sh

cblrepo-add-%:
	bash madd.sh $*	

cblrepo-pkgbuild-%: cblrepo-add-%
	cblrepo pkgbuild --ghc-version=7.8.4 $*
	$(MAKEDEPEND.package) $* >P/$*.P

cblrepo-tobuild: tobuild
	cblrepo pkgbuild --ghc-version=7.8.4 $(cat tobuild | xargs)

cblrepo-updates:
	@cblrepo updates	| grep -Fxvf blacklist | tr -d ':()' | tr ' ' '\t' 

yaourt-Rs-tobuild: tobuild
	yaourt -Rs $(cat tobuild | sed 's|^|haskell-|g' | xargs)

pacman-U-%:
	bash pacman-U.sh $*

%.src.tar.xz: %.pkg.tar.xz
	cd $(<D) && mkaurball && cp $@ ../aur

%.pkg.tar.xz:
	pacman -Q $(@D) || (cd $(@D) && makepkg -sci)
	
%/PKGBUILD: cblrepo.db
-include P/*.P
