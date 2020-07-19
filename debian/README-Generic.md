This Dockerfile works with several distributions.

Working `ARG RELEASE=...` values include:

From Debian:
  * potato woody sarge etch lenny squeeze wheezy jessie stretch buster bullseye stable testing unstable

From Ubuntu:
  * warty hoary breezy dapper edgy feisty gutsy hardy intrepid jaunty karmic lucid maverick natty oneiric precise quantal raring saucy trusty utopic vivid wily xenial yakkety zesty artful bionic cosmic disco eoan focal groovy

From Devuan:
  * jessie:devuan ascii beowulf chimaera ceres

From Kali:
  * kali-dev kali-rolling kali-last-snapshot

From PureOS:
  * amber

The `ARCH` option can be set to i386 for most of these (and is forced to i386 for some like Debian Woody)

The `MIRROR` allows you to set the mirror to use and then the `DEBSCRIPT` arg lets you use a deboostrap script different from the `RELEASE` name ("sid" is the normal fallback). The `DEBOPTIONS` arg allows you to add more options to debootstrap (eg if the GPG key fails).

The `INSTALL` arg is a list of packages to install just before the final cleanup.

I'm using the base64 stuff to make things prettier :-)
