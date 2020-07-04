#--------------------------------------------------------------------------#
# We could use any Linux that has debootstrap available.
# Ideally we want the smallest possible.
# Alpine is very small, but only has a Debian keyring.
# So I use git to fetch some others over https.
#
# Working 'RELEASE' files include the default "stable" and ...
# From Debian:
#   potato woody sarge etch lenny squeeze wheezy
#   jessie stretch buster bullseye unstable
# From Ubuntu:
#   artful bionic breezy cosmic disco eoan focal
#   groovy intrepid jaunty karmic maverick natty
#   oneiric precise quantal raring saucy trusty
#   utopic vivid wily xenial yakkety zesty
# From Devuan:
#   ascii beowulf chimaera ceres
# From Kali:
#   kali-dev kali-rolling kali-last-snapshot
# From PureOS:
#   amber
#
# However, some of the older ones have expired keys so you'll need to include
#   DEBOPTIONS='--no-check-gpg'
# and use a https MIRROR.
#
# The ARCH option from be set to i386 for most of these (and is set to
# i386 for some like Debian Woody)
#
# The MIRROR allows you to set the mirror to use and then
# the DEBSCRIPT arg lets you use a deboostrap script different
# from the RELEASE name ("sid" is the normal fallback).
# The DEBOPTIONS arg allows you to add more options to debootstrap.
#
# The INSTALL arg is a list of packages to install just before the
# final cleanup.
#
# I'm using the base64 stuff to make things prettier :-)

#--------------------------------------------------------------------------#
FROM alpine AS unpack
WORKDIR /root
RUN : Configure host ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA41TwW6cMBA9w1eMVlVWSmVQpfaC2p62VXOoEpH0lDYrgwewApiO7aT79x3A;\
_ pGyF1HIynjcz7808RxYdCPwVx5EcHkEqBUL0RpSybBAUFsY460gOMCC1UGvHyMNV/iH1llLb;\
_ SMJ0hUptSXpwlkEZ5DhITWAISkLpEByXPOCTlz0EXBJHFhW8h1dcM7Vawcf5qGbY9zgC/gTC;\
_ 3mYPj3gi3deQXGbLcUUjXNmQKySVjX5CEe6Teqiz/briW80CK+lbd+w0EfNsnBuydBSUzEUS;\
_ Q3XaIdWo9qyp7UFUFgK5iai0pdabkQLNs2+rzRgz6ySS3A4i4TzBG094fRuGtZAFbeHL3d3N;\
_ bRzdjzp2M4+uQNrBD7i4mBXWhAOIn5PShw2ddn+eOeZNyxB6ynmjwfejOw6fPh+nfsevV3l+;\
_ nZ/nrTf9rfC988tu43U1nnVlqMRjp94tBZ4ludPun7DGSDrNfUID3ihXZy9C2ZoeX3ZagJ8A;\
_ owOwXa4nsbxVxiet9H3ZDFIlPbo0oF9b47ln+F38Ekclz0/C+e0fl12Ohtr0XzJxDUb/m+ua;\
_ zcpj83Gx7otl+bkFGueR/6UxvmnFoxCC3WCsdoY0WlHpFmFslva+HaODZ4tPr/s371VR3xEE;\
_ AAA=;\
)|base64 -d|gzip -d>/tmp/install;sh /tmp/install;rm -f /tmp/install

#--------------------------------------------------------------------------#
WORKDIR /opt
ARG RELEASE=stable
ARG ARCH
ARG MIRROR
ARG DEBSCRIPT
ARG DEBOPTIONS
RUN : Stage 1 ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA41Vf2/iRhD92/4UUwcdOsRiVa1OFakr0QSpSJcQAa0qXdrTYg+wxez69gcc;\
_ CvnunfWaBJrLXZHQ2t6dmTczb95GBi0w/BxHfUimli8RvoeF0tCaDN8PB9MhtAaTq9+SOI6u;\
_ R5MsdUanZsU1pgXOlbLGal6lJteisiaOcm4QkqNtAkLGUaUst+qwU6rYHwzXFOIteKdZ0nrw;\
_ a5+JH35695jA5WUcFbh1XMLbOAL6XQ9/nV5NRnez7NnpZdhqXjNj+bzE8O1mNJmMJ95veOqz;\
_ lbVVP/Vge8FzT+llukFCUTwmweocC98U7348bnlEHYJ7AaMFSAXG5SsI2XZh6dAYELZtoBRr;\
_ ytuIorH7AN9RVakSVLS09fCURp8d06B0/4I3b+IoKiWwhQEy/vr5/wUWDc+pV2IBS40VsE/Q;\
_ /nuNey3kstdxcyeta38rjF2hhKvxzV2WMJarTaUkSmuyDReyq5FaLnKLRddJsUVtsLtxpQ2P;\
_ ZI0lUeA161xJsp53pZJsodGfXwjC+wx2y7XgdL7X2Qg5Jzp9A25dQ5/9H4PJaHA781EbH1nj;\
_ wZP3Am6csYCf89IVmApZr2AVLGkAiHBOFnxD9C/A7I3FzZe5/A91XHj+Dv+cTQZZm7HGYxas;\
_ im6zMlq3wFgTyG9vhRSWKqIpJd+qHdd2f1gprvdHur/wSv9tN7SN1cV46jRNCq8q1F839SGb;\
_ 4eweIfgmGFUis0qV5umNWrVR8rVgRHZrCC3XxetoT6O5igZT25oB3NblaGrDDOqtyNGc+ucm;\
_ F+IwR7Vz5eKQr8SGo+aHHIlvp+U+1jMMM2uoHQq65qVgnS+drne4JrdbPLdp5uVEzKhppH8o;\
_ ljSWtU1WKyC0GoJBy5MbWsTG8d1sNL6dwn1IpFXHPaVMvtLkFlpBjWqbwGAKmReQqsqm4Uzs;\
_ Bfha5Wvq6Iob4KVGTqUmeXYVpJVWeRwZYicTXljaJr3/ud776LfSPpy8tOFMm52wyEJbKMqH;\
_ U3wZBHGupQgeQhoXcOW0ppk9dVODmrtlOHIGBPOVgvvWw+/T4UdfmvHt8HY2fQzfk5cbyX8A;\
_ LpzMrSAWxtHjS4DNxJ0C9DdVmDIQhga34lS2AkLBKBkhiXplCbglHSMl3CEUSrYt7EgUSK97;\
_ ybMfBXOyWwNp3rFbtcbbFfdHyRCNN+W5deRzX8tFEwCLo6eTeqSNANz/0uukxXmmGj85obHw;\
_ iVK7j9etH5ESLZ7du/G/WR2ohJoHAAA=;\
)|base64 -d|gzip -d>/tmp/stage1
RUN set -ex;: $RELEASE; sh /tmp/stage1 && rm -f /tmp/stage1
# Configure apt and dpkg for docker
# Note: standard used "#" for comment not "//"
WORKDIR /opt/chroot
RUN set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA+1abY8btxG+z/oV0zUQO4G00kn34sqGASdGigPSwLAd5EuBgNqlVqx2yQ3J;\
_ lSw3+e99hlyddeeXokFP56Ac2He3Inc45HCeeYaU9MX45I5lArk8Pw+/Ibd/h79PZxfns9n0;\
_ dHJ2djI5ncxmkxM6PzmCdM4LS3RijfGf6/ef2v+kIuF/0frxl+V/yFny/zH9j/95YfQyL8df;\
_ gP9nk7OL5P978n9pirW0o6KWQv/P/H/Bfv24/6fTs9kt/5/jrxOaJP/fuYzH9FrpQtLSWGqM;\
_ 8/QiuJ86J60bUiuKtagkKY11qmtHK9G2UuOZsrhRaNGpuszIedm64QAK/UruSDontVd4Z0cL;\
_ WZiGdZRqo8pO1FSLHdRT2Unyhl+grdjth14JXdbSsarQT+lqCH2tLKK6zuET+s78TEuFfjuM;\
_ 3Lic6OeV8NClHDXYui5MqXOEZ4+W3jIqRLGS8SN6/vINrSXsJqlL6lr6J7YDTHGeR3CYPFuN;\
_ vsbJ3uYhNWKNVlZnOrufSae1LDBnYRUsrIXFmj06sNmFRd7Kh3VN2tgmfKjlJq50b5u7tk5U;\
_ AuNiHWir8AavvhRlNO/Wur/vCsMkCVpYPLBGLbekGnjv63zAz1el5GGH/VBb09W9ygVPc2N4;\
_ XpQBCkaV9BQAIBtiHM+LwJP1MqxM72UsIJZNhoVbSH632BW1KqLdkirjsSu6Yk1G81I/dFTD;\
_ 9CE5E5pl761lp1lhYaXwyuigGX0Pd1Cc+E3L8sGLl+tqPn+JXTu6YvMl/Ysy29BoSeONsOOw;\
_ mBHebLFSG+nG3+SlXHyytRWWB/x4r2/yBZbht9/I205mT+j3JwNMaj7/qS2Fl/dqx+CFsvP5;\
_ d9xlPm/XVehMWfbkRoOzxY02XvQfjZfRlfBIaQg+qNU7GR2jnH7oQ9Ao3johRhGupQnNw+Bn;\
_ YbHnarSEeDWMDeiykN5ji7quqnjLGETjo5X3rZuPx5Xyq26BbNOMMbtOWiuN37Xy1pNyrpMO;\
_ W/ckyX3kf21GtdBVB/xwd5r/J2fT2/zv4uJ0mvL/kfL/le4T7zBiAMe8WXoEspYAdw7/7A1y;\
_ iqsDPLsspt0exh8i/g+zZkgNCtmewSFm0MUOWre6NqLkJAGFTcSOCDJ6pRbKx4yMLP696clH;\
_ hKXSxFQWLcGLinODQEJt2loi5wWgYVSStfQ9cLGBYYTrlNEFkM5ymn89GDwvfu2UBSL+sN/g;\
_ lGmjAaaDFP/7+BedN1Y2ZiNHPYy7u4n/09nlxc34n06ml+cp/o/K/w9pf0jqtYl8kFk0Y4Bj;\
_ zopdQK1xTi0QYEulQQoCw3SBVHKkLk1dmy2/KBtpObQEhyuI7o6Q8hvwuzbErJ4HAkL06qcf;\
_ 6WaY0j9iC8tXX1039jUIjXb0tK9L3LNbfZ+CnDguNjBWqyJigena9bNPKG07pupQOQo7fhS3;\
_ /MEAwcpvAWFyKbraD0PREFi5KHwX2OkvXEP8sq+V3N5QQNZGCXrF1U8DpuzIWFb2QrbhSS2B;\
_ UQbrZq/LrNd9pPVYh/ogUnu4qO4CeuIl9kb/wjURN1ZV7A5YUwg4MaJlpGIH9gAb4wRLIO1r;\
_ kLQIyFwiBZzNlqJ2MgOvd509rJLQA4WfNa1VcBBGEVWFDg50lcTCoEQIent8Z1XvV8OTKFEm;\
_ xCJkzwKx/sp3pczBN7EGTHSV0LmxFQPQWOpxsZpM3eQc//KVb+oHDE+qeg6/PYejXkVo2i/Y;\
_ VdMa64X2A3SYz9/3mM8/6LKf5ZNELT+D/9U71Y5Qssu3d83/Ls8/5H98/pfw/77wP56wZB9B;\
_ 5o/DcZ7nGZ77Ywxle22BJ/aMsjpgaEguikEutgtwTbsVtnSBgG45QnvwYoXAL2SQkH34j+vs;\
_ Y/SoVO76NEG+bWtVKA9osvLXjhNVBK/WhyOeoDIcMyAxMHIBDXsVGMhcH7GYJezc99nT1Qhd;\
_ zEy5RVjljGYK+wG/jMdBSA9+xZgYkBUJSBBwk+lxQMYsYt18u5Ly3S6jhXAyplEm0ZRN/5o/;\
_ fkx//zbDeiA5yKCuJ8uBZ0NlvQuaHufTyxl3zQ9Y7d8QuVcxcCmLhwSDz8V/2a6ru7wA+gP3;\
_ P1N0T+f/R8L/4H/+kRfL6g4ugP7A/c/pxTT5/778vy8AAW2uReHdtXd8/nM6vZ3/zy9T/j+K;\
_ PAhZ7b+4+Ck7G7jBjUsITlSqWA0eINnLcGiM8mHDtUFrtuhVI2mHOgapkisQXnOPBBwO8g8I;\
_ APrsVmbLOR264lWO0lyAbqVYU8WH43ylI0grcJZ+d9KjpitW4SPL2da1Sms2kpO7G0KTWWyU;\
_ 6Vy945uQB0/NcvmM69pCjjrtxFKOlPk/rQU6Z7/I7/9cpPv/o/nfLZT+wvhfuP9P/j+i/1uD;\
_ 8mk3skVeHtv/s8vL2/zvbJK+/3Gc/P+XMXvfrZAXP0UFslsVfxbqz54QuE8wAqiLxWvI9eHr;\
_ FBKUoAgHApEj8LFsYAXxtmkpVM1np7TqGmORrvm+2eX0BjQA2lCQb6QOR6P8bQzuHY4oFzsM;\
_ Ydq2r9XfD7O0piE+am7aeMxpoi2gAPItCunTyWk6AEySJEmSJEmSJEmSJEmSJEmSJEmSJEmS;\
_ JEmSJEmSJEmSJEmSJEmSJMmfV/4NQR5c0wBQAAA=;\
)|base64 -d|gzip -d|tar xvf -

#--------------------------------------------------------------------------#
RUN : Stage 2 ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA61WbXMTNxD+bP+KbcgkpCBfHKC0oaRDS+gw0wmdQIcPNDCytHdWrZOEpHPs;\
_ Ifz3rqSznYRAS6ee8el1te/P7iBgBIaL4QAXzvoIT49/fv7k5N2z0xcnr45Pnj421igT0XMR;\
_ 1RyHw8EhKKMiBNtiVC0G6AJ9VBBTb22EaEGqwCcaoXOSRwyj4UDV8AbYAqowUabK9IznjS74;\
_ Ku+t6M+GgzhFA9LNGiaJJcnEmLaCaxo9Gt4iTbiUnxIPB5B+2gALkE+i7/Cme7XKmryaqgDW;\
_ RWUNTDzyWch6kYYhcq0DYHMI3aQzsataTrIoMRsOkmgkQm29QNaZwGtkygLTWWg4qiTOK9Np;\
_ DQdHO2PY2SlyBZTAFBkbdqu3t360dX0E196oQnXrzVs4+xaqahf+7PWhX4VRVOn1/BmJuhnJ;\
_ SloxQ8+4iyw4RNk5uLg4JMVIgAmpGaLn7vKchA4orJGM1GuQbhcOKKYWtl4/OT15fvLrIRwv;\
_ kn8jj12A2tsWvvAE2W/7py042jkgvoIHhK3t0+Pfjp+8PN4iMw4Hf2EICmGvcDqEl8sQsZWg;\
_ kewZgAOFULgLnXFczIAY84YrQ24oxhTcgMfWzolVHJVHevv3JCtHSHRoJPl9zn0luJhiRZap;\
_ uBdTiqJQhcL43bcjUmctjWqmEFMUrNy/DPMcn6PR/8GNpfeusjwt2lCQt1cYuM43+Mn7/TvZ;\
_ sf/6dua6ITmEF9O7wI2EWi3WGl5+Tn1Jj3ybCeuxV+SaJskuFAqBVOLkPo9gKI/Jq2iioqxN;\
_ jOndlDmJLoVry/0MeEdYwd6/h+3b670wtectNx3Xe5vbDUFUutzHwVr55dUrBW4+2SY0iqxz;\
_ jedyc/joEWlxzn1cwh7cgtd5poLZjSkilZlQJN9gb8rIAdeBsy4qQoc8TVdBKxpsZ+RBvqPn;\
_ 7Xgf6HuQPmS7tiWEmdrodNfkG62V5Q0nVJmkHU0gkIwdrdXhc/wJrmJHupCxE2963dSqAQI4;\
_ +QOb2kDbQbaUROXdRENXgtW4EmS1JHvx9SLzBOHpnEwmyNJ+nInXq3JfmlAexnlbPsyIzqci;\
_ UEcHZPKIi1jMksgbT0hXlsp528U05hcY906ZZr0kfBHoeJzCTNtGFktuDJumsR2nsZc5TTey;\
_ poUJ4+9WdFm0g9G9dNCIfN7ISVvWrm3yjpJmXCZBPFxRUrWZ1UpjPtDnHkOe9WqeP0gLJ7jb;\
_ Hz3cTL9fUROQSK0M3k9nQTXizh02Hh2wB2K8n7XowoTtj8aMLliyTkxRm2nD9Bx0sDXobAog;\
_ J+oFfQ2TkzS4nGat5LKlIG2Rhc7lop0jKnoWlVlC28UIhhsLhqoGRYkht9A/Z4cloAhhyoRW;\
_ lJ6Z0FHwU2ly1nWaexWXKaKobkfaCjFBRj+ymOLVuULlXB94NLOpJNTglnFK4VOGZHmPKqC/;\
_ T25vSiB6TPJOKAl8WBoBoSgaOmkTMBW/R+Fk1zqIqEmDTEcmK0E3V236ryL5/F4LizpkBpcy;\
_ W3Ln0F+gbJYXNcmQ0nwN+anArzGL6ktCqwlC0abzKEdfQNqCQWyDbkm67dvlroYL4OezVN/V;\
_ mz+enVUfnKfmCbYPHn3c3bskn0tOtxl6fi/TG7FnSQKm/8XXCuREKxRnIqNKds0Gby777Vry;\
_ r4tfaSMST2ICiS2V5Aw+UlK754HjFez5PKCwlAOZFPVchRKh9SR1nbWsdRemNBbJbkQPaiWd;\
_ cUW8a7mlLeS2MKUEnyE1XdBOfK9/D6ouxRExI5mTbdYhRhN6pltA5GEWsFitj7fFXEmJEUXs;\
_ bUCxedX2W9u02lodGlx7doCBi+G6Q1yHVKKkAk1gtzrre0UC82LIBDeBKKlNrjcN67ounlEX;\
_ SS30pd7qm8fQt1b57MPXFdfSHHzMTfAv1IoZqp6pJdn08aX1/k+9exHFt1dUudqj/0N331f6;\
_ zzfuL3PzeUCx1jpNvspxujLO8G8XIsrw1QwAAA==;\
)|base64 -d|gzip -d>tmp/stage2
RUN : Extras and Cleanup ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA2WRT08CMRDFz7uf4gFGEmKpXtdAYsSDCfGCiQf1UNpZ2Gxpl253ZQN8d7v8;\
_ 0YhNmrYz8355nYl6mNgvo61QEEYhM6UXWod7A0VpZkihEDIXCyrj6B3dq+eX2evDdNpFZ4R+;\
_ H5+4vsY2jhCWKDxbkEdVKOEJrPkbPrNZgzMljvZxHCV41CQMdFb68gZSyCUd3CxDwLpmGEeX;\
_ 6PUajLX1TLbSqgCzk8wlyZOXSTKzlZM0DekRV1RzU2n9yzgo4kgV+SJA2pdjohZZKHErsBSc;\
_ vOShut1DaU06VPz2TlTBC61sTSwnZ0iXP/W1cFxnc94i+YBZrY4pd8r5VcEHOB7hu7vQV3VS;\
_ 2eDBNwUhRQeMNiThibDd4+M+tKaHN+ty4WwVFKl1CGx0/1vvYl4thu2EAmUDXpWOzzPDVUma;\
_ pA9j2u1AcmkxHl/4PejFXFP8DXnrFM0NAgAA;\
)|base64 -d|gzip -d>tmp/stage3

#--------------------------------------------------------------------------#
FROM scratch AS stage2
COPY --from=unpack /opt/chroot /
ARG RELEASE
RUN set -ex;: $RELEASE; sh /tmp/stage2 && rm -f /tmp/stage2

ARG INSTALL
RUN sh /tmp/stage3 && rm -f /tmp/stage3

#--------------------------------------------------------------------------#
# Finally squash all the layers.
FROM scratch
COPY --from=stage2 / /
WORKDIR /root
CMD ["bash"]
