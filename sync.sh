#!/bin/bash
#set -ex
function diffPkgs ()
{
	hg diff -U 0 cblrepo.db | grep "^\+" | sed 's/^+//g' | while read p ; do echo $p | jshon -e0 -u ; done
}

function listPkgs ()
{
	cblrepo list | cut -d ' ' -f 1
}

function updatedPackages()
{
	cat uu | tr -d '():' | awk '{print $1}'
}

function updatedPackagesV ()
{
	updatedPackages | xargs --no-run-if-empty cblrepo build \
		| xargs -l --no-run-if-empty perl -e 'system("grep $ARGV[0]: uu")' \
		| tr -d '():' \
		| awk '{print $1 "," $3}'
}

function smartRm ()
{
	xargs cblrepo build | tac | xargs cblrepo rm
}


function makeDd ()
{
	bash upstream-repos/haskell-happstack/updates.sh -a | tee dd
} 

function stripx
{
	sed 's/:x[0-9][0-9]*//g'
}

function makeUu () 
{
	cblrepo updates | stripx | grep -vFf blacklist | tee uu
}

function buildOrderAll()
{
	cblrepo build $(cblrepo list | cut -d ' ' -f 1 | xargs)
}

function buildOrder()
{
	cblrepo build $(updatedPackages | xargs)
}

function bump ()
{
	cblrepo bump $(upstream-repos/haskell-happstack/updates.sh -b) $(updatedPackages)
}

function bumpAll ()
{
	cblrepo bump --inclusive $(cblrepo list | cut -d ' ' -f1 | xargs)
}
function goal ()
{
	cblrepo add $(updatedPackagesV | xargs) 
}

function dv ()
{
	hg diff cblrepo.db | cut -c 1-77 | grep "^[+-]"
}

function pretendUpdated ()
{
	echo "PretendUpdated"
	cblrepo add $(cat dd) $(updatedPackagesV | sed -e 's/^/-d /;s/$/,7777/'| xargs)
	echo "pretendUpdated done"
}
bash mkdist.sh
makeDd
makeUu
pretendUpdated
goal
#bumpAll
bump
goal
buildOrder > tobuild
dv | grep -v DistroPkg
