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
_ H4sIAAAAAAACA61X628UNxD/fPdXTEOU8PJt7oDShjYVLaFCakMVqPgAAfls7657Xtv4cQ8R;\
_ /veO7b27JARKq0a69XPe499MBl4EIGI5HIilNS7Ak+Ofnz0+eff09PnJy+OTJz9qo6UOwlEW;\
_ 5FwMh4NDkFoG8KYTQXbCQ/T4kZ61zpgAwQCXnk6VgGg5DcKPhgNZw2sgS6j8VOoq0xOaN6J3;\
_ Vd5b058NB6EVGridNYSjSNSJEGUYVTg6oWkncEI5/5R4OID0pzQQD/kkuCiuu1fLbMnLVnow;\
_ NkijYeoEnflsF1roA1XKg2gOIU6jDrHqKOoi2Ww4SKqhCrVxTJCoPa0FkQaIykrDUcXFvNJR;\
_ KZgc7Y1hb6/o5QUHItHZsF+9vfGDqesjuMKj8tWN12/h7DZU1T686e3Bv0oEViXu+TNidTPi;\
_ FTdsJhyhNhBvheDRwvn5IRqGCkzRTB8ctRfnqLQXzGhO0LxG4O0iQbDWwM6rx6cnz05+PYTj;\
_ ZYpvoCF6qJ3p4Ass0H+7P+3A0d4E5TLqBezsnh7/dvz4xfEOunE4+Et4LwXcKpIO4cXKB9Fx;\
_ UAL96YECppC/C1FbymaAgmlDpcYwFGcyqsGJzsxRVBgVJr3/e5J1ILiwQnOM+5y6ilHWigo9;\
_ U1HHWswiX/ki+N3tEZqz0UY2LYSUBevwr/w85+do9H9II4nfZZGnxRpM8u6SABtdIz7h3/PJ;\
_ gf3q21nqluQQnrd3gWoOtVxuLLzITn7JjnybMONEb8gVS5JfMBU8mkQxfE6AxneMURU6SHy1;\
_ STDyTS8n0d0cDgZRyS5hgIbxweR+0hSe5GSGJklFSIHx71BzTAzUBpiTGUYGKdU76mZAI+IM;\
_ ef8edm9u9nxrFh3Vkapb/dUGsS3d7BNo47XVhfMCUpf3EMACibZxlJeTpHefwY8eof0L6sIK;\
_ bsENeJVn0uv9kHJZ6im+gWsi9SaxV56SGCTiSp6mq6AkDiZqPsl31LwbHwB+J+mDXu86xKbW;\
_ BKtik290hhcelskySTsK4SOFKRij/OfkI9CFiCZhmJJs5K5r2QBCI/+etMbjtucdPr/CN9Hg;\
_ FW+UWCuyXqLP6GaRZWKQ8Bw9x9DVbpyJN6tyn2tfGIt5Vz5Es+hS+aiDBfR8EMtQ3JLIG4cY;\
_ WZbSOhNDGjMHQp2VutksEZmYsDS0MFOm4cWTW8emaejGaex1TtOtrmmh/fjbNV1WbTK6lw4a;\
_ ls8bPu3K2nZN3pFcj8vEs4drSqxTs1oqkQ/UwgmfZ72ZiwdpYRm1B6OH2+l3a2qEIK6kFvfT;\
_ mZcNu3OHjEcT8oDhM0l70U/JwWhM8IJB74SUuZnWtwtQ3tSgsisAg6iW+NWET9Ng8wPtOOUd;\
_ JmkniI82l/ucUcGRIPUKuhgCaKoNaKw3mCUaw4K//EIMQoz3LWFK4sPOhBaTH4uaNTYq6mRY;\
_ pYzCih9wy4cENv1IQspXawuVtX3i4cykYlKDXYUW06cMyfNOSC/cfQx7UxLRiaTvFB+B8yvN;\
_ wBdDfeQmQVqJe2CWx85CEAotyHTospJ0c9ml3zqTF/c6WNY+C7jwsjm1VrhzwZvVeY06pGe+;\
_ KRapNdigHVamhHNTAcWa6AQffQGjCwiRLS4m7XZvlrsKzoEuZqkzkK//fHpWfbAO2y7YnTz6;\
_ uH8ReWwKusnQ80eZXos9K1Qw/c7/rUKWdUxSwjKq5NBs8eZi3K48/k3ZLA1IkolCIInFYp7B;\
_ h3NsFB1QcQl7Pg8oJL2BTCrUXPqSofU09as1r1X0LY5Fs2vRA5tQq21R78rbUgZyQ5meBJ0J;\
_ bNegm7re/h5UbcojFIY6J99sUgwnyCYuIVA/86J4rc+35VxyLoJgofcB5uZl3+/s4mpnfajF;\
_ JrID4SkbbnrLTUolSiztCHbrs77LTHUxOzLBjUdKbLDrbau7qYpn2H9i832hK/vmR+ibsnz2;\
_ oejwtaW1tBUfc/v8CzZxGitoama2/wGUpv0/df1FFdddMuVyd/8P/xf0pf7zLf+L3LZOMNc6;\
_ qzBWOU/Xzhn+DVxkHdUPDQAA;\
)|base64 -d|gzip -d>tmp/stage2
RUN : Extras and Cleanup ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA32STW/UMBCGz8mveLugVqpw3EWcgrZSRfcAWjh0kTgAB689yZr1xqk/0kZN;\
_ /zvOfoBYEJGsJJ53Xj+emewrJi/v5ov5zXI+wQw/yHtN+I7z8zxDeqLRWx3AGkyvXr/BMJS4;\
_ tXJDDrXuyCN6TD+iUv4VRBsgnSZf5Hn2IskeGmOFgmgUdOODMCZ991BU6YYUWiE3oiafZyPE;\
_ +0/LzzeLxQRnM1xc7AjwtGdIxqymgNgqEQis/3P76M16HF3y7DkxlHhnSDQw2ofEJ4Vc045m;\
_ nTas64s8O7W+vwdjo57JMTW2YPZWu7KcB1mWSxudpEUKz7iijjfRmN8eu4w8U+2mTibjn2Oi;\
_ EzpJ3BasAqcgeVKPq5C2qQrFr6YiJhba2o5YKmtDxv/Sd8Jxo1d8tOSXzBq1D7lDLGxbfon9;\
_ K113SHVVhyybGELfEiqcgdEjSQQiPD3j29tde75YtxHOxpRRWYfkjcnf6BOsYl2MHUouj+DR;\
_ O77SDVeeDMmQ2jQMILm2uL4+4d3li5Whfx33YT9nx9J15Hp4Yx+gvY+0n4j/jeXhSO6sDbxY;\
_ Cb928mRW8584DFpD3AIAAA==;\
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
