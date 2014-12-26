#!/bin/bash

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
	cblrepo build $(updatedPackages | xargs) \
		| xargs -l perl -e 'system("grep $ARGV[0]: uu")' \
		| tr -d '():' \
		| awk '{print $1 "," $3}'
}

function smartRm ()
{
	xargs cblrepo build | tac | xargs cblrepo rm
}

function makeDd ()
{
	bash appstack/updates.sh -a | tee dd
} 

function makeUu () 
{
	cblrepo updates | grep -vFf blacklist | tee uu
}

function buildOrder ()
{
	cblrepo build $(cblrepo list | cut -d ' ' -f 1 | xargs)
}

function bump ()
{
	cblrepo bump $(appstack/updates.sh -b) $(updatedPackages)	
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
	cblrepo add $(cat dd) $(updatedPackagesV | sed -e 's/^/-d /;s/$/,7777/'| xargs)
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
