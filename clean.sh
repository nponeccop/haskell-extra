cblrepo list -d --no-repo| awk '{print $1}' | xargs -l cblrepo rm

