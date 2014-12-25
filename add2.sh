#!/bin/bash

function add
{
	local foo x version aaa
	x=$(awk "/^haskell-$aaa / {print \$2}" distpkg)
	if [[ $x ]]
	then
		echo $1-$x is queued for installation
		cblrepo add $(echo $x | tr "-" ",")
		echo $1 >>installation.log 
	else
		echo $1 should be queued for packaging
		echo $1 >>packaging.log
		foo=$(cblrepo add $(bash version.sh $1) \
			| awk '$1 != "Failed" { print $1}')
		for aaa in $foo 
		do
			add $aaa
		done
	fi
}

truncate --size 0 packaging.log
truncate --size 0 installation.log
add $1
yaourt -S $(cat installation.log)
tac packaging.log
for aaa in $(tac packaging.log)
do
	echo packaging $aaa
	bash build.sh $aaa
done

