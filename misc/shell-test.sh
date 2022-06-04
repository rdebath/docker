#!/bin/sh -

true || exec sh -c 'echo WTF is this!; exit 1'
(exit $?0) || exec sh -c 'echo Try a Bourne shell; exit 1'

# Plain env variables to display names.
case $BASH_VERSION in *.*) { echo "bash $BASH_VERSION";};;esac
case $ZSH_VERSION  in *.*) { echo "zsh $ZSH_VERSION";};;esac
case "$VERSION" in *zsh*) { echo "$VERSION";};;esac
case  "$SH_VERSION" in *PD*) { echo "$SH_VERSION";};;esac
case "$KSH_VERSION" in *PD*|*MIRBSD*) { echo "$KSH_VERSION";};;esac
case "$POSH_VERSION" in 0.[1234].*) \
     { echo "posh $POSH_VERSION, possibly slightly newer, yet<0.5";}
  ;; *.*|*POSH*) { echo "posh $POSH_VERSION";};; esac
case $YASH_VERSION in *.*) { echo "yash $YASH_VERSION";};;esac
(eval 'V="${.sh.version}"&&[ "$V" != "" ]')2>/dev/null>&2&&
    (eval 'echo "Ksh ${.sh.version}"')

# A couple of initial tweaks to fix possibly ill advised defaults.
(eval 'shopt -s lastpipe')2>/dev/null && shopt -s lastpipe
(eval ': ${var:=value}')2>/dev/null && {
    (eval 'set -o sh && set +o sh') && set +o sh
    (eval 'set -o posix && set +o posix') && set +o posix
} >/dev/null 2>&1

FAIL=
POSIXSHELL=yes

(eval 'a(){ exit 0;}'; a; exit 1)2>/dev/null>&2||
{
    echo 'ERROR: This non-POSIX shell is ancient (pre 1984), it has no functions!' >&2
    exit 1; FAIL=yes ; POSIXSHELL=no
}

(eval 'P=21 ; [ "$((P*(2)))" = 42 ]')2>/dev/null||
{   # Bash <=1.12, ksh88
    echo 'This shell does not have arithmetic substitution. (POSIX)' >&2
:   exit 1; FAIL=yes ; POSIXSHELL=no
}

[ "$POSIXSHELL" != yes ] || {
    (eval 'P=1 && : $((P+=1)) && [ $((P)) = 2 ]' ) 2>/dev/null||
    {
	echo 'This shell does not have arithmetic assignment operators. (POSIX)' >&2
    :   exit 1; FAIL=yes ; POSIXSHELL=no
    }
}

[ "$POSIXSHELL" != yes ] || {
    (eval 'P=1 && : $((M$P=3)) && Q=500 && : $((M$Q+=1)) &&
       : $((M$P+=1)) && [ $((M$P)) = 4 -a $((M$Q)) = 1 ]' ) 2>/dev/null||
    {
	echo 'This shell does not have parameter expansion within arithmetic expansion. (POSIX)' >&2
    :   exit 1; FAIL=yes ; POSIXSHELL=no
    }
}

(eval '[ "$(echo ok)" = ok ]')2>/dev/null||
{   # Bash <=1.12, ksh88
    echo 'This shell does not have command substitution. (POSIX)' >&2
:   exit 1; FAIL=yes ; POSIXSHELL=no
}

HAS_LOCAL=yes
(eval 'X=1;x() { local X;X=2;};x;[ "$X" = 1 ]')2>/dev/null||
{   # Bash <=1.12
    echo 'This shell does not have the local command.' >&2
:   exit 1; FAIL=yes; HAS_LOCAL=no
}

FAIL2=no
(eval 'X=1;x() { typeset X;X=2;};x;[ "$X" = 1 ]')2>/dev/null||
{   # Bash <=1.12, ksh88
#   echo 'This shell does not have typeset local in standard functions.' >&2
:   exit 1; FAIL=yes; FAIL2=yes
}

FAIL3=no
if (eval 'X=1;function x { :;};x;[ "$X" = 1 ]')2>/dev/null
then
    (eval 'X=1;function x { typeset X;X=2;};x;[ "$X" = 1 ]')2>/dev/null||
    {   # Bash <=1.12, ksh88
	echo 'This shell does not have typeset local in ksh functions.' >&2
    :   exit 1; FAIL=yes ; FAIL3=yes
    }
else
    # Bash <=1.12, ksh88
    echo 'This shell does not have ksh functions.' >&2
:   exit 1; FAIL=yes ; FAIL3=yes
fi

[ "$HAS_LOCAL" = no ] && [ "$FAIL2" = yes ] && {
    if [ "$FAIL3" = yes ]
    then echo 'This shell does not have local variables.' >&2
    else echo 'This shell does not have local variables in standard functions.' >&2
    fi
}

HAS_ARRAY=yes
(eval 'x[2]=3;x[1]=2;[ "${x[2]}" = 3 ]')2>/dev/null||
{   # Bash 2.0, ksh88
    echo 'This shell does not have array operators' >&2
:   exit 1; FAIL=yes ; HAS_ARRAY=no
}

HAS_PROC_SUBS=yes
(eval '[ "$(cat <(echo ok) )" = ok ]')2>/dev/null||
{   # Bash 2.0, ksh88
    echo 'This shell does not have process substitution.' >&2
:   exit 1; FAIL=yes ; HAS_PROC_SUBS=no
}

(eval 'X=1;((X=1+2))&&[ "$X" = "3" ]')2>/dev/null||
{   # Bash 2.0, ksh88
    echo 'This shell does not have arithmetic commands.' >&2
:   exit 1; FAIL=yes
}

(eval 'x=1;[ "$(set -- ${x:+0 "$x"} 2;echo "$2")" = "1" ]')2>/dev/null ||
{   # Bash 2.0
    echo 'This shell does not have alternate substitution with embedding.' >&2
:   exit 1; FAIL=yes
}

[ "$HAS_PROC_SUBS" = yes ] && {
    (eval 'x=X;y="$(cat ${x:+-v <(echo "$x") } )";[ "$x" = "$y" ]')2>/dev/null||
    {   # Bash 2.0
	echo 'This shell does not have alt & process substitution combos.' >&2
    :   exit 1; FAIL=yes
    }
}

(eval 'x=(1 2 3 4);[ "${x[2]}" = 3 ]')2>/dev/null||
{   # Bash 2.0
    echo 'This shell does not have array assignments. ' >&2
:   exit 1; FAIL=yes
}

(eval 'x="\"ok\"";[ "${x//[^\"]/}" = "\"\"" ]')2>/dev/null||
{   # Bash 2.0
    echo 'This shell does not have pattern substitution.' >&2
:   exit 1; FAIL=yes
}

HAS_SUBSTRING=yes
(eval 'line=nnynnn; j=2; [ "${line:$j:1}" == y ]')2>/dev/null||
{   # Bash 2.0
    echo 'This shell does not have substring operators.' >&2
:   exit 1; FAIL=yes ; HAS_SUBSTRING=no
}

HAVE_TEST2=yes
(eval '[[ yes != no && 1 == 1 ]]')2>/dev/null||
{   # Bash 2.02
    echo "This shell does not have the [[ command." >&2
:   exit 1; FAIL=yes ; HAVE_TEST2=no
}

(eval '[ "$(cat <<< ok)" = ok ]')2>/dev/null||
{   # Bash 2.01, ksh88
    echo 'This shell does not have here strings.' >&2
:   exit 1; FAIL=yes
}

HAVE_ANSI_STR=yes
(eval "x=\$'1 \062 ';[ \"\$x\" = \"1 2 \" ]")2>/dev/null||
{   # Bash 2.02
    echo 'This shell does not have ANSI-C like strings.' >&2
:   exit 1; FAIL=yes ; HAVE_ANSI_STR=no
}

[ "$HAVE_ANSI_STR" = yes ] && {
    (eval "x=\$'1 \x32 ';[ \"\$x\" = \"1 2 \" ]")2>/dev/null||
    {   # Bash 2.02
	echo 'This shell does not have (hex) ANSI-C like strings.' >&2
    :   exit 1; FAIL=yes
    }
}

(eval '[ "$((12**2))" = 144 ]')2>/dev/null||
{   # Bash 2.02
    echo 'This shell does not have the exponentiation operator.' >&2
:   exit 1; FAIL=yes
}

(eval '[ "$((42,3,9))" = 9 ]')2>/dev/null||
{   # Bash 2.04
    echo 'This shell does not have the comma operator.' >&2
:   exit 1; FAIL=yes
}

[ "$HAVE_TEST2" = yes ] && {
    (eval 'x=1.12.123.234;[[ "$x" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]')2>/dev/null ||
    {   # Bash 3.1.x
	echo 'This shell does not have regexs in [[.' >&2
    :   exit 1; FAIL=yes
    }
}

HAVE_SEQBRACE=yes
(eval 'x=$(echo {1..3});[ "$x" = "1 2 3" ]')2>/dev/null||
{   # Bash 3.0
    echo 'This shell does not have sequence brace expansion.' >&2
:   exit 1; FAIL=yes ;HAVE_SEQBRACE=no
}

[ "$HAVE_SEQBRACE" = yes ] && {
    (eval 'x=$(echo {A..C});[ "$x" = "A B C" ]')2>/dev/null||
    {   # Bash 3.0
	echo 'This shell does not have alpha brace expansion.' >&2
    :   exit 1; FAIL=yes
    }

    (eval 'x=$(echo {01..03});[ "$x" = "01 02 03" ]')2>/dev/null||
    {   # Bash 4.0
	echo 'This shell does not have padded brace expansion.' >&2
    :   exit 1; FAIL=yes
    }
}

if [ "$HAS_ARRAY" = no ]
then
    HAS_ASS_ARRAY=no
    HAS_IND_ARRAY=no
else
    HAS_ASS_ARRAY=yes
    (eval 'typeset -A x;j=A;k=B;x[$j]=C;x[$k]=0;[ "${x[$j]}" = C ]')2>/dev/null||
    {   # Bash 4.0
	echo 'This shell does not have associative arrays.' >&2
    :   exit 1; FAIL=yes ; HAS_ASS_ARRAY=no
    }

    HAS_IND_ARRAY=yes
    (eval 'typeset -a xi && xi[2]=tst && :')2>/dev/null ||
    {   # Ksh '08
	echo 'This shell does not have Ksh indexed array typeset.' >&2
    :   exit 1; FAIL=yes ; HAS_IND_ARRAY=no
    }
fi

(eval "x='HelLO ';[ \"\${x,,}\" = \"hello \" ]")2>/dev/null||
{   # Bash 4.1
    echo 'This shell does not have case modification.' >&2
:   exit 1; FAIL=yes
}

[ "$HAS_SUBSTRING" = yes ] && {
    (eval 'x=ab.cde;[ "${x::-4}" = "ab" ]')2>/dev/null ||
    {   # Bash 4.2
	echo 'This shell does not have negative substring operators.' >&2
    :   exit 1; FAIL=yes
    }
}

[ "$HAS_LOCAL" = yes ] && {
    (eval 'a(){ local -n r=$1;r=OK;}; b=no; a b;[ "$b" = "OK" ]')2>/dev/null ||
    {   # Bash 4.3
	echo 'This shell does not have pass by reference (local -n).' >&2
    :   exit 1; FAIL=yes
    }
}

[ "$HAS_IND_ARRAY" = yes ] && [ "$HAS_ASS_ARRAY" = yes ] && {

    (eval 'unset qq;(typeset -A qq);(typeset -a qq)')2>/dev/null ||
    {   # Ksh
	echo 'This shell has leaky subshells. (BUG)' >&2
    :   exit 1; FAIL=yes ; unset x qq
    }
}

(eval 'typeset -i10 xa')2>/dev/null ||
{   # Ksh88
    echo 'This shell does not have Ksh integer base setting.' >&2
:   exit 1; FAIL=yes
}

(eval 'typeset -E xf && xf=10.5')2>/dev/null ||
{   # Ksh88
    echo 'This shell does not have Ksh floating point variables.' >&2
:   exit 1; FAIL=yes
}

(eval 'typeset -b x')2>/dev/null ||
{   # Ksh '93
    echo 'This shell does not have Ksh base64 variables.' >&2
:   exit 1; FAIL=yes
}

(eval 'x=0;echo 1|read x;[ "$x" = 1 ]')2>/dev/null ||
{   # Bash 4.2
    echo 'This shell does not have in process pipe tails.' >&2
:   exit 1; FAIL=yes
}

case $BASH_VERSION in *.*) {
(eval '[ "$(env x="() { :;}; echo bad" bash -c ":")" != bad ]')2>/dev/null||
{
    echo 'WARNING: Bash shellshock bug detected! (BUG)' >&2
:   exit 1; FAIL=yes
}
};;esac

[ "$POSIXSHELL" = yes ] ||
    echo 'This shell is not POSIX.' >&2

# Note:
#  As of 01/01/2018 no shell "passes" all tests; this is probably a good thing.
[ "$FAIL" != yes ] && echo "You're good to go."
