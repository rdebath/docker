#!/bin/sh -
true , /^; exec awk -f "$0" -- "$@" ; exit #/ {}
BEGIN { # vim: set filetype=awk:
    sh = "sh"; txtmode = 0;
    dsed = "sed 's/^@//' <<\\@";
    for(i=1; i<ARGC; i++) {
	if (ARGV[i] == "-b") {
	    sh = "sh|docker build -t '" ARGV[i+1] "' -"
	    ARGV[i] = ""; ARGV[i+1] = "";
	}
	if (ARGV[i] == "-x") {
	    ARGV[i] = "";
	    txtmode = 1;
	    dsed = "sed -e 's/^@//' -e 's/^#TXT# *//' <<\\@";
	}
	if (ARGV[i] == "-d") {
	    sh = "cat";
	    ARGV[i] = "";
	}
    }

    print "#!/bin/sh"|sh
    print "encode() {"|sh
    print "  N=\"${1:-/tmp/install}\""|sh
    print "  D=\"${2:+;$2}\";D=\"${D:-;sh -e $N;rm -f $N}\""|sh
    print "  S=$(sed -e 's/^@//' -e '0,/./{/^$/d}')"|sh
    if (!txtmode) {
	print "  echo 'RUN set -eu;_() { echo \"$@\";};(\\'"|sh
	print "  printf \"%s\\n\" \"$S\" | gzip -cn9 | base64 -w 72 | sed 's/.*/_ &;\\\\/'"|sh
	print "  echo \")|base64 -d|gzip -d>$N$D\""|sh
    } else {
	print "  echo 'RUN set -eu;_() { echo \"$@\";};(\\'"|sh
	print "  printf \"%s\\n\" \"$S\" |bash -c 'while IFS= read -r line"|sh
	print "  do echo _ \"${line@Q};\\\\\""|sh
	print "  done'"|sh
	print "  echo \")>$N$D\""|sh
    }
    print "}"|sh

    mode=0; ln=""; ty="";
}

# Embedded docker file in dockerfile() function, or append after "DOCKERFILE" line
/^#!\/bin\/[a-z]*sh\>/ && mode==0 { mode=3; ln="encode<<\\@\n"; }
mode==3 &&/^dockerfile\(\) *{ *$/ { print dsed|sh; mode=4;next;}
mode==4 &&/^RUN *$/ { mode=5; next;}
mode>=4 &&/^} *$/ { print "@"|sh; mode=3; next;}
/^DOCKERFILE/ && mode==3 { mode=0; ln=""; next; }
mode==3 { if (substr($0, 1, 1) == "@") ln=ln"@"; ln=ln $0 "\n"; next; }
mode==5 { if (substr($0, 1, 1) == "@") ty=ty"@"; ty=ty $0 "\n"; next; }
END { if (mode>=4) ln="@\n"ln;}

# Standard Dockerfile with BEGIN and COMMIT translation
/^BEGIN$/||/^BEGIN /{ if (mode) print "@"|sh; mode=2; $1="encode<<\\@"; print|sh; next }
/^RUN <<COMMIT *$/{ if (mode) print "@"|sh; mode=2; $0="encode<<\\@"; print|sh; next }
/^COMMIT *$/ && mode==2 { print "@"|sh; mode=0; next; }
mode==0 { print dsed|sh; mode=1; }
mode!=0 { if (substr($0, 1, 1) == "@") print "@" $0|sh; else print $0|sh; }
END { if (mode) print ln"@"|sh; mode=0; }
END { if (ty!="") { print dsed|sh; print ty"@"|sh;}}
