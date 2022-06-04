#!/bin/bash

BEST=ffffffffffffff
# Found 0000126 37318057351be95b7f9102564b330938e 1544457
# Found 000009d 46a9880c1278e4e28f7ddbfe0970acd98 2878055
# Found 0000045 6c344547156a67f3eef4606a793898cee 593756
# Found 0000005 a5b0ef3401f90363268cacfc252e90b3f 4164808
# Found 0000003 78637db9a77b983b88a85d7e1ceb73239 43964458

c=593750
c=102611506

NILTREE=$(git hash-object -t tree -w /dev/null)

while [ $c -lt 1000000000 ]
do

NULL=$(echo "tree $NILTREE
author nobody <> 1 +0000
committer nobody_$c <> 1 +0000

 
" | git hash-object -t commit -w --stdin )

echo -ne " $c \\r"

[ "${NULL:0:2}" = '00' ] && {

    echo -ne " $c $NULL\\033[K\\r"

    [ "${NULL:0:3}" = '000' ] && {
	NBEST=$( { echo "$NULL" ; echo "$BEST" ;} | sort | head -1 )

	if [ "$NBEST" = "$NULL" ]
	then
	    echo -e "\\033[KFound $NULL $c"
	    BEST="$NBEST"
	    BCNT="$c"
	fi
    }
}

c=$((c+1))

[ "$((c%10000))" = 10 ] &&
    git gc --prune=now -q

done

echo -e "\\033[K$BEST $BCNT"
