function parse_rel()
{
	awk 'BEGIN{OFS="\t"}; { match($2, /(.*)-(.*)/, a);$2=a[1];$3=a[2]; print $1, $2, $3 };'
}
function list ()
{
	cblrepo --db $1/cblrepo.db list $2 $3 | parse_rel
}

function list_hg ()
{
	cblrepo --db <(hg cat $1/cblrepo.db) list $2 $3 | parse_rel
}

function list_pkgdest ()
{
		ls ~/build/pkg/ -1 | perl -pe 's/(.*)-(.*)-(.*)-i686.pkg.tar.xz/\1\t\2\t\3/'
}

function list_syncrepo ()
{
	pacman -Sl $1 | cut -d ' ' -f 2,3 | parse_rel	
}

function list_hgam_pkgbuild ()
{
		hg stat -am | awk 'BEGIN{FS="[ /]";} $3 == "PKGBUILD" { print $2}'
}

function list_subdirs ()
{
	ls -d */ | tr -d '/' | grep -vEx 'oldaur|patches|upstream-repos|upstream|oo'

}

function myaur()
{
	cat aurhaskell | awk '$7=="zoidberg_md" {print}' | cut -f 1,3 | parse_rel | sort
}

function all_unmarked_aur()
{
	cat aurhaskell | awk '$5==0 {print}' | cut -f 1,3 | parse_rel | sort
}

function mkjoin()
{
	join <(list . $2 $3) <(list upstream-repos/$1) 
}

function pkgrel()
{
	mkjoin $1 -d --no-repo | awk 'BEGIN {OFS="\t"}; $2==$4 && $3!=$5 {print "'$1'", $1, $2, $3 " -> " $5 }'  
}

function pkgver()
{
	mkjoin $1 -d --no-repo | awk 'BEGIN {OFS="\t"}; $2!=$4 {print "'$1'", $1, $2, $3, "->", $4 , $5 }' 
}

function adopted()
{
	mkjoin $1 | awk 'BEGIN {OFS="\t"}; {print "'$1'", $1, $2, $3, "->", $4 , $5 }' 
}

function all_upstream()
{
	list upstream-repos/$1 $2 $3 | cut -f1

}

function dropped ()
{
	join -v1 <(list . -d --no-repo) <(repos all_upstream | sort)
}


function repos
{
		for p in upstream-repos/* 
		do
			$1 $(basename $p)
		done
}

function bumped()
{
	awk 'BEGIN {OFS="\t"}; $2==$4 && $3 + 1 == $5 {print "'$1'", $1, $2, $3 " -> " $5 }' | column -t
}

function wrongly_bumped
{
	awk 'BEGIN {OFS="\t"}; $2==$4 && $3 != $5 && $3 + 1 != $5 {print "'$1'", $1, $2, $3 " -> " $5 }' | column -t
}

function newver ()
{
	awk 'BEGIN {OFS="\t"}; $2!=$4 && $5 == 1 {print "'$1'", $1, $2, $3, "->", $4 , $5 }' | column -t
}

function wrong_newver ()
{
	awk 'BEGIN {OFS="\t"}; $2!=$4 && $5 != 1 {print "'$1'", $1, $2, $3, "->", $4 , $5 }' | column -t
}

function db_changes()
{
		bash dbdiff.sh | tail -n +2 | cut -f 2 -d ' ' | sort | uniq
}

function ghc_diff ()
{
		join <(list . -g --no-repo) <(list upstream-repos/$1 -g --no-repo) | awk 'BEGIN {OFS="\t"}; $2 != $4 {print}'
}

function ghc_promo ()
{
		join <(list . -g --no-repo) <(list upstream-repos/$1 -d | sort) #|sed 's/$/\t-\txx/' # | awk 'BEGIN {OFS="\t"}; $2 != $4 {print}'
}

function ghc_foo
{
		join -v1 <(list . -g --no-repo) <(list upstream-repos/$1 -g --no-repo) #|sed 's/$/\t-\txx/' # | awk 'BEGIN {OFS="\t"}; $2 != $4 {print}'
#		join -v2 <(list . -g --no-repo) <(list upstream-repos/$1 -g --no-repo) |sed 's/$/\t-\txx/' # | awk 'BEGIN {OFS="\t"}; $2 != $4 {print}'
}


echo "==> Package upgrade only (new release):"
repos pkgrel | column -t

echo "==> Software upgrade (new version):"
repos pkgver | column -t 

echo "==> Adopted packages (our RepoPkg in upstream)"
repos adopted | column -t
echo "==> Dropped packages (our DistroPkg not in upstream)"
dropped | column -t
echo "==> AUR packages to upload (new release)" 
join <(myaur) <(list . | awk 'BEGIN{OFS="\t"}; {$1="haskell-" tolower($1); print $1,$2,$3}' | sort) | awk 'BEGIN {OFS="\t"}; $2==$4 && $3 + 1 == $5 {print "'$1'", $1, $2, $3 " -> " $5 }' | column -t
echo "==> AUR packages to upload (broken bumping)" 
join <(myaur) <(list . | awk 'BEGIN{OFS="\t"}; {$1="haskell-" tolower($1); print $1,$2,$3}' | sort ) | awk 'BEGIN {OFS="\t"}; $2==$4 && $3 != $5 && $3 + 1 != $5 {print "'$1'", $1, $2, $3 " -> " $5 }' | column -t
echo "==> AUR packages to upload (new version)"
join <(myaur) <(list . | awk 'BEGIN{OFS="\t"}; {$1="haskell-" tolower($1); print $1,$2,$3}' | sort ) | awk 'BEGIN {OFS="\t"}; $2!=$4 {print "'$1'", $1, $2, $3, "->", $4 , $5 }' | column -t
echo "==> AUR packages to mark outdated"
join <(all_unmarked_aur) <(list . | awk 'BEGIN{OFS="\t"}; {$1="haskell-" tolower($1); print $1,$2,$3}' | sort ) | awk 'BEGIN {OFS="\t"}; $2!=$4 {print "'$1'", $1, $2, $3, "->", $4 , $5 }' | column -t
join <(all_unmarked_aur) <(list upstream-repos/haskell-core | awk 'BEGIN{OFS="\t"}; {$1="haskell-" tolower($1); print $1,$2,$3}' | sort ) | awk 'BEGIN {OFS="\t"}; $2!=$4 {print "'$1'", $1, $2, $3, "->", $4 , $5 }' | column -t
echo "==> Bumped packages:"
join <(list_hg . | sort) <(list . | sort) | bumped 
echo "==> Incorrectly bumped packages:"
join <(list_hg . | sort) <(list . | sort) | wrongly_bumped
echo "==> New versions:"
join <(list_hg . | sort) <(list . | sort) | newver
echo "==> Incorrectly bumped new versions:"
join <(list_hg . | sort) <(list . | sort) | wrong_newver
echo "==> Deleted packages:"
join -v1 <(list_hg . | sort) <(list . | sort)
echo "==> Affected but not bumped:"
join -v1 <(cblrepo build $(db_changes|xargs) | sort) <(join <(list_hg . -d -g | sort) <(list . -d -g | sort)) | column -t
echo '==> Non-unique versions in patches/*.pkgbuild'
grep -ho "haskell-[0-9a-z-]*=[0-9.-]*" patches/*.pkgbuild |sort|uniq | cut -d '=' -f 1 | uniq -c | awk '$1 > 1{print $2}'
echo '==> Non-unique versions in PKGBUILD'
join <(grep -ho "haskell-[0-9a-z-]*=[0-9.-]*" */PKGBUILD |sort|uniq | cut -d '=' -f 1 | uniq -c | awk '$1 > 1{print $2}'| sort) <(grep -ho "haskell-[0-9a-z-]*=[0-9.-]*" */PKGBUILD |sort|uniq | tr '=' '\t'| sort)
echo '==> Newly built packages'
join <(list_pkgdest | sort) <(list_syncrepo haskell-extra | sort) | awk '$2 == $4 && $3 == $5 { print $1}'
echo '==> Modified but not built'
join -v1 <(list_hgam_pkgbuild | sort) <(list_pkgdest) 
echo '==> Modified, built but not bumped'
join <(list_hgam_pkgbuild | sort) <(join <(list_pkgdest | sort) <(list_syncrepo haskell-extra | sort) | awk '$2 == $4 && $3 == $5 { print $1}')
echo '==> Repo packages without directories'
join -v2 <(list_subdirs | sort) <(list_syncrepo haskell-extra)
echo '==> Directories in upstream'
join <(list_subdirs|sort) <(list_syncrepo haskell-core | sort)
join <(list_subdirs|sort) <(list_syncrepo haskell-happstack | sort)
echo '==> GHC packages different from upstream'
repos ghc_diff | column -t
echo '==> GHC packages promoted in upstream'
repos ghc_promo | column -t
echo '==> GHC packages not in upstream' 
ghc_foo haskell-core | column -t

