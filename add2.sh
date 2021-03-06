#!/bin/bash
function inrepo()
{
		grep RepoPkg $1/cblrepo.db | cut -d \" -f 2 | grep -Fx $2 >/dev/null
}

function already_installed()
{
	echo checking $1
	pacman -T $(echo $1 | tr '[:upper:]' '[:lower:]') >/dev/null && echo "$1 is already installed"
}

function add
{
	local foo
	if inrepo core $1
	then
		echo $1 is queued for installation
		x=$(cblrepo --db core/cblrepo.db list $1 | cut -d ' ' -f 3 | sed 's| +|,|g;s|-|,|g')
		cblrepo add -d $1,$x
		already_installed haskell-$1 || echo haskell-$1 >>installation.log 

	elif inrepo appstack $1
	then
		echo $1 is queued for installation
		x=$(cblrepo --db appstack/cblrepo.db list $1 | cut -d ' ' -f 3 | sed 's| +|,|g;s|-|,|g')
		cblrepo add -d $1,$x
		already_installed haskell-$1 || echo haskell-$1 >>installation.log 

	else
		already_installed haskell-$1 && return
		inrepo . $1 && echo "inrepo $1" && return
	    echo "not inrepo $1"
		echo $1 should be queued for packaging
		$(cblrepo list $1)
		echo $1 >>packaging.log
		foo=$(cblrepo add $(bash version.sh $1) \
			| awk '$1 != "Failed" { print $1}')
		[[ $foo ]] || (echo "successfully added $1" && return)
		for aaa in $foo 
		do
			add $aaa
		done
		# echo "secondary addition of $1"
		# cblrepo add $(bash version.sh $1)
	fi
}

truncate --size 0 packaging.log
truncate --size 0 installation.log
(inrepo core $1 || inrepo appstack $1 || inrepo . $1) && echo Already available && exit || true
add $1
x=$(cat installation.log)
[[ $x ]] && yaourt -S $x
echo "Secondary addition of $1"
add $1
tac packaging.log
for aaa in $(tac packaging.log)
do
	echo packaging $aaa
	bash build.sh $aaa
done

