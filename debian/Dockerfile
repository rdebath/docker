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
_ H4sIAAAAAAACA+NMLMhWSExJUdDVzcvXTU5MzkhVSElNys8vKS4pSixQKEgtylFIzyzhAgBw;\
_ 6Nk8KQAAAA==;\
)|base64 -d|gzip -d>/tmp/install;sh /tmp/install;rm -f /tmp/install
RUN : Configure debootstrap ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA61VXW/TMBR9Tn7FVUGEFTXW0HhpV7SHMTEh2NSNJ8omN7lNrSVxsJ3u+79j;\
_ x3aXVBFsiL408b2+95xzPxJIVDDCmzA4PJ5NSS0FkSsqkKS44FxJJWhFZCJYpWQYBmOIZlhR;\
_ JuAQF4yW4ExRGEhMdSCI9iikuKR1ri4LJgQXsFKqGhNCRbJia4zT5mbMRUbsYwTzMAD924fB;\
_ aw2DXK8Q724H8LHzHr8fhEGx3j7r3rEYv3E1ErjmVxqTA3qFt7DUYCquqOIeL2sgy4OL+Vvt;\
_ IFiZzXcgHh7Md4EIzZ9Y95E2xlmVHUQumz222Zwg3xd1qWovSCf+HjOpE7ws0g8+wjUVSsP9;\
_ m9uKU2Hc8hJGSwlZreStM2Ua4HorhPQqz+O6wUN4nmopcqQSpT/zwVNaVSgsiyN24ym4EOAU;\
_ kVsZ2lqRV0YpH69B1wVEur0QD9t4NiCpzwWtDvTpiXUaOVj6dsHXmJqaSFOUl2TfVudFid35;\
_ S3NWXCj5vzOGAb2+2gyMPdzMS/NqRkPPVXQ0ne7eVzqMmpR4oyaPetbIHUp1u0Pg3g5eY4aB;\
_ bsllnT8kXBYseUiZTPjOoOPRP9k9PRYnvHBsuhH+jX03xmTi3o+muxMwhBzBx6i1ITYqbAk3;\
_ 9n1uGigMMqYgyXmJfguNFuBqleIac39suEpNVvvHOa3LZFXRNC5ROdjkneS1nl7PwqEPg6SC;\
_ EYXu6RPnoaHXq0bc3i5a7EQgVQhqhXqnreun5Rvb/tuHhqdkqW4EO9/WzfMy0zu+8AWIh+M/;\
_ 1cLe7avFOGpH1Eurvyn0bo9tkGbVFygyTKNws8ocuAYolQljvZYF8us6X/baNLKCoqD9RhRo;\
_ v1hOrO1qt+vZwmkfPf0NbaZ8IbuW5xfytBZ4cuZq5jUDJuHz+fnpWRj8MHLaVqXFQq9l+Alv;\
_ 3lihM4E6969G8IseuWXUvWnutXfSLoO6NF/6w09Hl02+y6/Hs9nJrHuvwfmF5gxWVILWrIkN;\
_ NlEH4ZV2agN8Xi7dNsHme9ulsfns+rKY/9ikaapiHg5sgBaA8Df5GJw9vggAAA==;\
)|base64 -d|gzip -d>/tmp/install;sh /tmp/install;rm -f /tmp/install
RUN : Debian Potato key ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA42U+T/UCQPHv3PlGs0gYzbHzjhzDxO9WtdYx5SUcZ85Z4YZzRDjWjeRlljb;\
_ EsKYlUKEMQm76NAmYVlyhMgRoYwMyTi2fZ4fnl+eH/YP+Lw/P3w+r3cx6FeoqXmfrhQU2Kfj;\
_ Up8fnlGUG+7dd2dMeBv0XQQphKZHj7CObLyKYiMqpYSSFGTaR3N6i+SSSlWaZ47HVoFu6NGw;\
_ N3o+Lxo8F0dfNi/uMO9SGzdKrOTHfsZx8d9fqoDYZnoo6TqVKxdXJgRpOR/Y9HMqyIeqFoUj;\
_ ZAOr3NfpN+UQV4Tdgljcx3mg4uFwTFPYDcFatXpJI9Fkkn8QCt6HAiujdBOLuQXV6Gi/3J2k;\
_ 5r0y/3OKCgsbyps+E9Wqhu1dc+bZyJFGtH1qm/Wpv8CuBYzLhieXHo7p5H1E93sqIhvTu4os;\
_ M4ss3GebyErbI1wNbiAnrCmBy1a69Ac4hfR5HJJKcvVrLkRlk2c8CstnCud7NRuwap2HLtAQ;\
_ ShzTeBIKcFoNNI5eKidH22fsbhry1meM+C0A+scM6NVrLCM93fNeYi9ymZVJEu/NigzdSpwj;\
_ x08L+D1pIj4aGZXbd0MsbJllB9NT6yNb7qo1oiOjG7Q/8dEm3Tew75PmqoMc505xP8FDTWWb;\
_ OqU+hKbDrLynkq84PY16L3dpvmffOejzp5B03vfWlEBaABNjGREUQoumYCyjWGGMABYtCONM;\
_ C2bSmMGYc5Q4zAlDHM5QE2NKZYUzAiJZlAgC+T8xvbCIYPOsi1AZKTCgCAP/MzdMDLTCBGAS;\
_ IuIQKEQWAoagwCCwXAogLoasTVyNj9A//oH3E1CKEC336bMepIfu6hgAOpUQvM+8OcB23r6I;\
_ VZZESG467oyTfyPVvKUMJmRR/g1e+n94EQqRRARAoK81bJuycAcefJlxOiF87wJdNSn1TlwY;\
_ wHbr6syAlSqpCultQy63Cb1Blj1pbVDJr3ftb0ciAf6YpNRN6TYKvGUr/PgxYh/UYWzkwUIq;\
_ trnAV6Ylwkn01sx0V1I27ob2sD8Zoc9T6OMLvDk/7xaeC9YX+OyiBEqJN1XLXWw7rpq54NiQ;\
_ 5xl1PfDEP+bthB1NvYG6s49/OJr559JxPWNN4Bl9IGBWBIc8c6veIjCPi/ocdTnpXaRKzCJU;\
_ cLVWi3lXZ9CubTbfCCXj418BO12HO3VMJ68nzDcy9HbGJqfHg2RoZK2dbSZ756VX+g2wlWJw;\
_ rd068PFWfO5KifHnOCxCWePRmsN+tVsjcbgXcPfd4QR4KPZg8OsDrRMdE/g8WfgmKC7HtyNZ;\
_ PfXxhHqJNLtUuCruJiPZ3Tf0NCYIomlNlax6pX20TM+/aklzYfG+9vOU9XKJzEE1IvQ+duuB;\
_ n7v98h3RelifkLZj6ObXlXKwzoQ3lg65gNXd+CwGG7QahCA+0J874nJQljdU8WEH7UXrVpHQ;\
_ LyzKj+hpGWnLfxYCKGIbY5fUBPRWa57940Z1mzU/6iwhvxz+Bg10y3rKGBFcVjG76hlNERj9;\
_ 3/1lDcOdd3Y3HIKszq5F7EQNNPkLYn70Nhcvz3HMjZYueFaV+4gT4J64wvK++MRRDkWjLddF;\
_ gs2EdAMuP/68qxVc+bsNWuy7M1327wjdKVOu0UsGrzOb+4u4koVNDC5v3+JyXrjGgrkO7hwA;\
_ gSEObYNEIhO6BaSrXu+aTPOSS73FDl6s2lnuqXLiJni1KdRX980On1hQnS5vLvIa3qIaHO6B;\
_ V0jYe9OPpBgB78MUNi7YuC5uNpBqgh9y8M4b7nOO+idVQr9AVo6gaBWImJv2wf5iSE7IPZF5;\
_ fGOrrBj7N+ZLrKfKvSqv7NPMVp4fVEUP6WOshqe/LfZG46fXD8g28c/Q3+5mf4rTZk26+Ejf;\
_ XtWfqQvZ/jJgg5IHivpG12UHfBMeT7X9vmfJyZGaUCLXDqTWT+rW9IhyRS3x1oLrb9R1ilxh;\
_ E4Hb8pMBDdyONWtSoBDedS1FyuOvVX9IFkGb0NPeSRngqxUrdNSLJ5Bw/nPDfQtdvyQGEw6o;\
_ WlUm3jom1Ed1hkMwG8cL3z0oEhZr/TpO8Jsrk+ERExWjx7LRvhEaVnhq90+zqH5tEP9Nukoq;\
_ Kz6XN4W43y6m3eka2CIMVqkXri4Xfzm2uTCdbCIvag61xD7Xq67pIhKKxZKmro0SCcuoAqHi;\
_ Aca1ikN2nInT0duH+YvGHIEzT9TeIknrseXLA2pETi18o5fUciUrbePpysY3IO2qtWbPs+xv;\
_ sTnEZMqguYlwyPQsloi9TelvkMRsNcWOT0M0FsxQ+XGRU8e2FTq8vPdeXJ/6obLwvJZ435ck;\
_ BpI1kXMdsv46pUi11xaJHasLMXZkt51IOpnlAkV/1Q78H+30t/9XO//PMhnrANvuiTww8jRf;\
_ sMtX0vWhHg5uxUpxgPITTowPEpP9VIvDHXQHJi8hQ81W+W9h/YCYFQcAAA==;\
)|base64 -d|gzip -d>/root/potato-key.gpg

WORKDIR /opt

#--------------------------------------------------------------------------#

ARG RELEASE=stable
ARG ARCH
ARG MIRROR
ARG DEBSCRIPT
ARG DEBOPTIONS
RUN : Stage 1 ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA91W227bRhB9Fr9iQhMWYogm6hZB4VQBVFtABdQXSE5RwE6DFTkSNyJ36b1I;\
_ UU3/e2eXlE3XdvLWhwoQVtTO9czMGfY0Gojxa9A7hnBm2BLhB1hIBdF0/Pt4NBtDNJqe/BYG;\
_ Qe90Mh0mVqtE50xhkuFcSqONYlWiU8Uro4NeyjRCuNMNgYugV0nDjKw3UmbbWjNFLt6CMzoM;\
_ ozt3Hsf8x5/f3Yfw/j25QZPmdYFCkPCtRfwb601OxxbeBj2gD1/ANfnwYcGbIThl+NTcmRzJ;\
_ Y2+psIL4FtZ6q1NWFJBUSqZJFCUlqzTUNdyRlFPANJfwYf8IwvF0ejE9hlOccyYe01d4a7lC;\
_ 7Uw/2iuxlGoLGlPDpTgMn1kbZdmD9BBLWzCDQLA+/CeY4WsEI2GFSmABqSxLJjIouMCXDBaG;\
_ 5LxSsQVLMLuAfO5MpTk3FIpVHc2v3MDRET3dN9AseHN6kDdMmW2dS6a29Vw5dOuMVRWqGrPl;\
_ tl4g13S/tEaTFFNUOC4Mgcqz+guzgu5WTJU8/W9q8nFOLu3/vSYHNBZ7MFmAkKBtmkMzVQNY;\
_ WtQauOlrCmRF86V5FjaK1/CGppeQp+FMorvT8a+zk+nk8uo43oFFY/UJ9vfJZyEgXmgg5W/L;\
_ P4TUQ83SoPd0VFmZvfvp3vEB1XxX0/5fK9wqLpaHB9bXqv89F64p4OTi7HIYxjHBXEmBwuhh;\
_ ybgYUGmN4qnBbGAFgas0DqhcpvlJ2lgQ1q9pp5Jalc8HQop4Qb1N8oRz0HsMds0UzbjRhwcl;\
_ F3OirO+E6/FzoPwxmk5G51fOa2tj2FpwgOzBmdWGqpwWNsOEC3+6dloSyRKpWJGxkig2A+o4;\
_ g+XLfPmFqs0dR47/vJqOhv04bi0OG61s0J4xnWuI49aRu15zwQ0hoiglV8HOnO9G9ZlV+q4H;\
_ TdliD0anJxtS+Laqc9kugMEuBFcELQuMjZSFfnhy8yTFa846dPOqx64zW2lD+fkGYMaj0UIT;\
_ a1RrnqLummc65byeo9zYYlHTeJYMFatTdEzSQXsHJ+VmmYjbzm7wXLGCxwcvSfsbP/VrfKrj;\
_ p4igfNyXVDNasciXNJFeZ+iZE6K2vyByvQ0RNePF5dXk4nwGN00ikffb7Zg0V2QWorOJ40qv;\
_ 0zQwuUwzSGRlkkYmcDv+VKbEbZAzDaxQyDJHmMZWDRsHPU3NGXPHKX2d3Pzi7z57oj6GzkMf;\
_ nqx/S1QXN2UhL9fd+IbQ7H/PQo7iXRp7cGKVopHtmvFBze2yEXkSiKfcm+ju42z82UFzcT4+;\
_ v5rdN/+Hzy/CfwW4sMIvBXpDuX8eYDtw3QDdy1AzZMA1zW3FCLYMGsAoGS6o9Wjn4JpojIhw;\
_ g5BJ0TewIU4gqj4MH+1IoA3LVn43tNXy9G5y5kRJEbVTZbQsyObWs0XrALOdpQ4eSTv/Nx8O;\
_ D5LsaabtasxcolTu3RudG5ECad11X+2CfwDiM0Lq/QkAAA==;\
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
_ H4sIAAAAAAACA21SXW/TMBR9Tn7FaUGbNOF4QzwFddLE+gAqPFAkHoAH175pTd0480e2aNl/;\
_ x2naAYVIVhLfc46P7z3ZN0xffp4v5jfL+RQz/CTvNeEHzs7yDOmJRu90AKtxdfn6Dfq+xK2V;\
_ W3JY65Y8osfVR1TKv4JoAqTT5Is8z14k2H1trFAQtYKufRDGpO8Oiipdk0Ij5FasyefZYOL9;\
_ p+WXm8ViiskM5+d7B3gcPSRhtqaA2CgRCKz7e/uozTocVfLsKXko8c6QqGG0D8mfFHJDezeb;\
_ tGFdV+TZqfTdHRgb8EwO1NiA2VvtynIeZFkubXSSFqk844paXkdjfmvsGXmmmu06iQx/jolW;\
_ 6ARxO7AKnILkCT2sQtq6KhS/vBIxeaGdbYmlttZk/DO+FY4bveKDJL9g1qix5A61sGv4BcZX;\
_ um6f+qoOLJs8hK4hVJiA0QNJBCI8PuH72/14vlq3Fc7GxKisQ9LG9F/rU6ziuhgmlFQewKN3;\
_ fKVrrjwZkiGNqe9BcmNxfX3id88XK0P/O+7DmLNj61pyHbyx99DeRxoT8RzLyR+57Ptx+Icz;\
_ ubM28GIl/MbJk7DmvwDcYNgO3QIAAA==;\
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
