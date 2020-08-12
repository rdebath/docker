#!/bin/sh
true , /^; exec awk -f "$0" -- "$@" ; exit #/ {}
BEGIN { # vim: set filetype=awk:
    sh = "sh"; txtmode = 0;
    for(i=1; i<ARGC; i++) {
	if (ARGV[i] == "-b") {
	    sh = "sh|docker build -t '" ARGV[i+1] "' -"
	    ARGV[i] = ""; ARGV[i+1] = "";
	}
	if (ARGV[i] == "-x") {
	    ARGV[i] = "";
	    txtmode = 1;
	}
    }

    print "#!/bin/sh"|sh
    print "encode() {"|sh
    print "  N=\"${1:-/tmp/install}\""|sh
    print "  D=\"${2:+ $2}\";D=\"${D:-;rm -f $N}\""|sh
    print "  S=$(sed -e 's/^@//' -e '0,/./{/^$/d}')"|sh
    if (!txtmode) {
	print "  echo 'RUN set -eu;_() { echo \"$@\";};(\\'"|sh
	print "  echo \"$S\" | gzip -cn9 | base64 -w 72 | sed 's/.*/_ &;\\\\/'"|sh
	print "  echo \")|base64 -d|gzip -d>$N;sh -e $N$D\""|sh
    } else {
	print "  echo 'RUN set -eu;_() { echo \"$@\";};(\\'"|sh
	print "  echo \"$S\" |bash -c 'while IFS= read -r line"|sh
	print "  do echo _ \"${line@Q};\\\\\""|sh
	print "  done'"|sh
	print "  echo \")>$N;sh -e $N$D\""|sh
    }
    print "}"|sh

    mode=0; ln="";
}

/^#!\/bin\/[a-z]*sh\>/ && mode==0 { mode=3; ln="encode<<\\@\n"; }
mode==3 &&/^dockerfile\(\) *{ *$/ { print "sed 's/^@//' <<\\@"|sh; mode=4;next;}
mode==4 &&/^} *$/ { print "@"|sh; mode=3; next;}
mode==3 { if (substr($0, 1, 1) == "@") ln=ln"@"; ln=ln $0 "\n"; next; }
END { if (mode==4) ln="@\n"ln;}

/^BEGIN\>/ { if (mode) print "@"|sh; mode=2; $1="encode<<\\@"; print|sh; next }
/^COMMIT *$/ && mode==2 { print "@"|sh; mode=0; next; }
mode==0 { print "sed 's/^@//' <<\\@"|sh; mode=1; }
mode!=0 { if (substr($0, 1, 1) == "@") print "@" $0|sh; else print $0|sh; }
END { if (mode) print ln"@"|sh; mode=0; }
