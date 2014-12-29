join -j1 -v1 \
	<(join -j1 -v1 \
		<(cat top-pkg | sort) \
		<(cblrepo list --db core/cblrepo.db | awk '{print $1}' |  sort)) \
	<(cblrepo list --db core/cblrepo.db | awk '{print $1}' |  sort) | sort -t ' ' -k 2 >top-notincore

