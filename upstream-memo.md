DistroPkgs are not really distribution packages, but packages of an "upstream" packager a user decides to synchronize with. Now `happstack` goes in sync with `habs`, and my private repo goes in sync with both.

`updates`, `add` and `bump` could benefit from special support for (multiple) upstream `cblrepo.db`.

`updates` command could compare local distpkgs with upstream packages and notify about discrepancies:
- dropped packages: a local DistPkg is not in upstream
- promoted packages: a local RepoPkg is also present in upstream
- updated packages: an upstream package is newer than a local DistPkg
- upstream ghc packages differ
- downgraded packages (an upstream package is older) - really a sign of problems

`add` command could:
- pull missing DistPkgs from upstream
- warn if adding an upstream package is attempted

