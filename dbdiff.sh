hg diff cblrepo.db | cut -c 1-77 | grep -vE "^([ @]|\+\+\+|---)" | cut -d \" --output-delimiter=' ' -f 1,2,4,9

