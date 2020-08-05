#!/bin/sh
# vim: set filetype=awk:
true , /^; exec awk -f "$0" -- "$@" ; exit #/ {}

BEGIN {
    sh = "sh"
    print "#!/bin/sh"|sh
    print "encode() {"|sh
    print "  sn=\"${1:-/tmp/install}\""|sh
    print "  echo 'RUN set -eu;_() { echo \"$@\";};'\"(\\\\\""|sh
    print "  sed 's/^@//' | gzip -cn9 | base64 -w 72 | sed 's/.*/_ &;\\\\/'"|sh
    print "  echo \")|base64 -d|gzip -d>$sn;sh -e $sn${2:+ $2};rm -f $sn\""|sh
    print "}"|sh
    in_sect=0;
}
/^#!\/bin\/[a-z]*sh\>/ && in_sect==0 { print ":<<\\@"|sh; in_sect=3; next;}
/^FROM / && in_sect==3 { print "@"|sh; in_sect=0; }
/^BEGIN *$/ && in_sect!=2 {
    if (in_sect) print "@"|sh
    in_sect=2
    print "encode <<\\@"|sh
    next
}
/^COMMIT *$/ && in_sect==2 { print "@"|sh; in_sect=0; next; }
in_sect==0 { print "sed 's/^@//' <<\\@"|sh; in_sect=1; }
in_sect!=0 { if (substr($0, 1, 1) == "@") print "@" $0|sh; else print $0|sh; }
END { if (in_sect) print "@"|sh; in_sect=0; }
