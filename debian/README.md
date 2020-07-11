This repo contains debootstrap images for all Debian versions since "potato".

Version-|Tag            |Notes
--------|---------------|--------------------
2.2     |potato         |i386 only
3.0     |woody          |i386 only
3.1     |sarge          |i386 only
4.0     |etch           |amd64 uses vsyscall
5.0     |lenny          |amd64 uses vsyscall
6.0     |squeeze        |amd64 uses vsyscall
7.0     |wheezy         |amd64 uses vsyscall
8.0     |jessie
9.0     |stretch
10.0    |buster         |AKA stable
11.0    |bullseye       |AKA testing
sid     |unstable

The Dockerfile also works with several other distributions.

Working 'RELEASE' files also include:

From Ubuntu:
  * artful bionic breezy cosmic disco eoan focal groovy intrepid jaunty karmic maverick natty oneiric precise quantal raring saucy trusty utopic vivid wily xenial yakkety zesty

From Devuan:
  * ascii beowulf chimaera ceres

From Kali:
  * kali-dev kali-rolling kali-last-snapshot

From PureOS:
  * amber

However, some of the older ones have expired keys so you'll need to include
  `DEBOPTIONS='--no-check-gpg'`
and, preferably, use a https `MIRROR`.

The `ARCH` option can be set to i386 for most of these (and is forced to i386 for some like Debian Woody)

The `MIRROR` allows you to set the mirror to use and then the DEBSCRIPT arg lets you use a deboostrap script different from the RELEASE name ("sid" is the normal fallback). The DEBOPTIONS arg allows you to add more options to debootstrap.

The `INSTALL` arg is a list of packages to install just before the final cleanup.

I'm using the base64 stuff to make things prettier :-)
