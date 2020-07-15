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
# The INCLUDE arg is a list of packages to include during stage 1.
#
# STAMP is a flag to invalidate the docker cache for stage 1.
#
# I'm using the base64 stuff to make things prettier :-)

#--------------------------------------------------------------------------#
FROM alpine AS unpack
WORKDIR /root
RUN : Configure host ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA+NMLMhWSExJUdDVzcvXTU5MzkhVSElNys8vKS4pSixQKEgtylFIzyzhAgBw;\
_ 6Nk8KQAAAA==;\
)|base64 -d|gzip -d>/tmp/install;sh -ex /tmp/install;rm -f /tmp/install
RUN : Configure debootstrap ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA61VXW/TMBR9Tn7FVUGEFTVW0XhpV7SHMTEh2NSNJ8omN7lNrSVxsJ12n/8d;\
_ J7azpIpgQ/Slie/1veec+xHv6GQ+I6UURK6pQBLjknMllaAFkZFghZK+700gmGNBmYAjXDKa;\
_ gzUFvicxhhFCsE8hxhUtU3WVMSG4gLVSxYQQKqI122AY1zdDLhJiHgNY+B7o3wEMXmsYZLtG;\
_ vLsdwMfOe/h+4HvZZvese8dg/MbVSOCGX2tMFug13sJKgym4ooo7vKyGLA8vF2+1g2B5stiD;\
_ cHi4GAMRmj8x7iNtDJMiOQxsNnNssllBvi/LXJVOkE78fValjvAqiz+4CFsqlIb7N7c1p6Jy;\
_ S3MYrSQkpZK31pRogJudENKpvAjLGg/haaylSJFKlO7MBY9pUaAwLI7ZjaNgQ4BVRO5kaGtF;\
_ XlVKuXg1ui4g0u2FcNjG04CkLhe0OtClJ8ZpZGHp2xnfYFzVRFZFeUn2XXVelNievzRnwYWS;\
_ /zuj79HtdTMw5rCZl/q1Gg09V8HxbDa+L3QYNc3xRk0f9ayRO5Tqdo/AvRm82gwD3ZKrMn2I;\
_ uMxY9BAzGfEH4zno+PXPd0+nhRHPLKduhH/ToBtjOrXvx7PxFCpaluZj0NoTjRY78k1ct1dt;\
_ 5HsJUxClPEe3i0ZLsBWLcYOpO664Sk1W+4cpLfNoXdA4zFFZ2OSd5KWeYcfCove9qIARhe7p;\
_ E+dhRa9XjbC9Y7TYkUCqENQa9WbblE8rODRdeAA1T8li3Q5myo2b41XN8OTSFSAcTv5UC3O3;\
_ rxaToB1Rr67+ptAbPjRB6oWfoUgwDvxmoVlwNVAqI8Z6LUvk2zJd9do0soyioP1GFGi+W1as;\
_ 3Wq369nCaR4d/YY2U66QXcvzC3lWCjw9tzVzmgGT8Pni4uzc935UcppWpdlSL2f4CW/eGKET;\
_ gTr3r1rwyx65ZdC9Wd1rb6YxgzKXqODo0/FVne/q68l8fjrv3qtxfqEpgzWVoDWrY4NJ1EF4;\
_ rZ3aAJ+XS7eN13x1uzSaj68rS/UfVmnqqlQPhyZAC4D/G1dTOi+7CAAA;\
)|base64 -d|gzip -d>/tmp/install;sh -ex /tmp/install;rm -f /tmp/install
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
ARG INCLUDE
ARG STAMP
RUN : Stage 1 ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA81WbW/bNhD+bP+KqyrES2ZFW1sUWzoXcBMDM9C8wE6GAc0W0OLZZi2RKkk5;\
_ 9aL89x0pOZYbp/k2rEDBWLw3Pnf33LWOIBhbNkP4GaZKQzgafBz0xwMI+6Pj3yEcX/ZPL4J2;\
_ u3UyHPXiwujYzJnGmONEKWusZnlsEi1ya9qthBmEYG0iACHbrVxZZlV5qxRflYZp8rQPznYv;\
_ CO/ceRSJ17+8vQ/g3TtygzaZlylKScJfCsR/sLyd07GC/XYL6J+Ywify4TQDeNEDpwx/VXd2;\
_ juSxNdOYQ/QFlmZlEpamEOdaJXEYxhnLDZQl3JGUU8BkruD93isIBqPR+egITnAimNygoPFL;\
_ ITQaZ3pjL8NM6RUYTKxQ8jB4ZK3P+YN0D7MiZRaB0H34JpkVSwSrYIFaYgqJyjImOaRC4i6D;\
_ qSU5r5SuoCCYXUD+7Uwnc2EplEI3NL8KC69e0a/7CpqpqE4P8i3TdlXOFdOrcqIduiVneY66;\
_ RD5blVMUhu5nhTUkxTQlTkhLoApefmaFpLsF05lI/pucXE3IZfG/yclTyG6BsBODXe3RzIWD;\
_ 08s7Oz8kzNYgUYDxMospmPwmE/KGca73A4hmFt789Ct5gb09D1/rWewkIjffMRtsW9HIiwS5;\
_ w8R7UtKDPlfGgkNmyY0CLgybpMgrXQ/P6/ohBFELDUt21OAB0cBLGE5BKjBFMoeKRbowK9AY;\
_ ELZjCPgFAWaEM13h8gIiByGRURzenQw+jI9Hw4vLo2j9QKIRhwa5TSVEUwOk/H35h5DqQLep;\
_ iWX87Zt7x3+U3nUNd/5e4EoLOTs8KDy+nedcuAKA4/PTi14QRVRWuZIorellTMgulbLVIrHI;\
_ u4WkCtQGu1SetvqTtDGlunlKO1HUmmLSlUpGU+plkiec261NsEumidOsOTygLE+oBp8J1+Pn;\
_ QPmjPxr2zy6d19pGr7bgAHkJpwWVAX5N0oJjLKQ/XanM0FUHFJKzjCYLB6o0i9nu+fCZsi3c;\
_ TBj8eTnq9zpRVFvsVVq8W58RnUuIotqRu14KKSwhoulJLoPf9JJ7wyOr9H/ZrdIWeTAaNVmR;\
_ 4PdVnct64HXXIbgkGJViZJVKzcMvxx9KPuWsQa9Pemw6K3Jj6X2+AJj1aNTQRAb1UiRoOk0z;\
_ QehPCDobzGb5bNmMYTetl2mR0LeMUQGKZFESMdrHMT5lk5lEiHKC6rZIpyXNpoyhZmWCjrL3;\
_ H+sTqAWTUd1SVSIXLBXRwS5pf+NH3hK3dXz7Ug43iwkVC600KGZEBV6nVy81dWFD6JoKQuqC;\
_ 84vL4fnZGK6rh9TQhXfDs+OPVyeDox+DTQhh/TG4X4s3SjqZa3IP4enQEbC3XXUYhZZwiFVu;\
_ 40qGPtC+oRIaNjBnBliqkXE3wWyRVxTdbhnqnkg40uuY+Po3f3fj2fsIGj86sLWPFbQPRFXd;\
_ kJdPzfh6UC1kD0PDxf8SjgutiVOaZnxQk2JWiWwF4gfEdXh3NR7cOAjPzwZnl+P76nvw+CL4;\
_ JsBpIf2UppXx/nGANSM0A3RLasUCIAwRS84INg4VYPQYIak3aAnAJfEsMfUtAleyY+GWSItm;\
_ yWGwsaOAVh628IOszpafP3bOnCgponGqjDYqsrnydFY7QL621MAjrgnq+v3hQcy3X1rvKtw9;\
_ lNK93rRdD6dI+0dz5W7/C89EkiaMCwAA;\
)|base64 -d|gzip -d>/tmp/stage1
RUN sh -ex /tmp/stage1 && rm -f /tmp/stage1
# Configure apt and dpkg for docker
# Note: standard used "#" for comment not "//"
WORKDIR /opt/chroot
RUN set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA+1abW8bNxL2Z/2KuQ1Qp4XeZUk5NQiQNmhh4K4IkhT9ckBB7Y5WPO2SW75I;\
_ Ua79750hV7aixj20d5ZThAMntsTZ4ZBDPs9wuOjywcU9y5BkPp2G3ySnv8Pfo8lsOBkNr+b8;\
_ /Wg4GY8uYHpxBvHWCQNwYbR2v6f339r/ooIUf9G4wccV/9FoOE3xP2f86V8/12rVLwYfQfwn;\
_ w8k8xf+B4l/ofIOmJ7zTBmu9xZ71ZYnW2f8h/rOrq7viP5rMZ+/Hfzwcz2YXMEzxv3cZDOC1;\
_ VDnCixB18BaNBWEQKq03UpWw0gbcGsHWoqpoFUCjrZXLCmEllahA1oIWR5d1OmRtpatK7/hB;\
_ rNFQCwj6gS2aPeS6rrWCRjiHRi06rA/w6vvvgJZfr0QHvimEQ/hXbGH57LObRqkoVlUFvT08;\
_ bUS+4X6fneg+LTRYXSP31chKOEkd7rTZPLvDaOPJSTbZCyu+F5f8UQfBy6/2UOBK+Mp14fnL;\
_ N7CT5IfInSd/9vDjBrH5EQ6PHBzFArZSwCvkcaMqLGjDxl5gEz7JFQilad7M4VF43e40ns26;\
_ C7hFRToFWcwrX/Cs0kMcjfYBNufWwpFlWXI4yJtcUBCLYAGchiUe+SMtxAEWfYDX6BybdGv6;\
_ 2mm2la1EZTEDVNYbtNE2D5g0RNMY3RhJAaJeRFmSgpU0V2KpvYt2o7ng1u1sOBBFQT2GmVw7;\
_ 19jFgAFHOl9gX1SS5qBf4FIK1demZAAaoBrk6+HYDqf001+7unrE8CTL5xS35xSoVxGaDhN2;\
_ XTfaOKFchxQWi1uNxeI3KodRftm5+OTlbvzPKxTq/8b/v4P/4/HV5IT/p5PROOH/WfGfYb7W;\
_ BO/HRNC9AaYWQiysCQYIlKSCLC4UWHpZFRlYh43tRkDCPRA2oHIyINKSEZBtFHIrC8JMqMSe;\
_ eabwyBDFgLYT+0PXa0I8Yho2FfQIVAgKbYN5NOctw8zX+gdiINLbU8+1JTz7gcEqgFlNS9eG;\
_ IXnL0MUw1npG8Jivj5GNsdsS4BVEPvBvWg7kig24aGnw7DXpaoutz12oBfMim9PeHEbilcKc;\
_ xiyMJA8rwaTy+MhnGyZ5h5fEG0qbOnypCN/DTLe+2RvvRClkRP7ANDz7KIro3sm836qSYwTG;\
_ sDT0gS0q3EV2/jxC73WB3G237WqnfdWaDByxjXyfHZgxAEDWpX6YesNgHYaZ6d7QDk0bholb;\
_ Ij+b7/NK5tFvhFI7WhU+3wBxME31paWkIt90iaBDM7bRWnnFBnODka7ZMuker6A48Pc963de;\
_ vNyUi8VLWrW9a3Yf4T+QmRp6KxhshRmEyYzwZvI1UZUdfMFEc2drIwx3+GGtL/pLmoaffwZn;\
_ PJEH/PJlhwa1WHwfcpYH9aPzQprF4mtWWSyaTRmUISOGO26wJn+vjSf9O03pVgglRYRyJ4pB;\
_ Jd9hDIy06tKFTSN56YQ9Stu10KG5G+LMqaKoqCXsV83YEJIOTvGgPThQUC08PjB/Kd3aL4lt;\
_ 6gGNzqMxqN2+wZNP0lqPlpZuIukH4f/ynWx6BNn4Fu298v9wPj09/89mfP5P/P9Q57/IsNkH;\
_ TmYfPo71+/2MPrc0Jk1rLdAzwQWjSEm4gRUGtCEulXzIie1iRVCxE6YgRNlxIqDc4fDCBomb;\
_ 6AQZTp/8x83pU6teIe0Nm+DbhqhHOiILgz95PqhGim9coPhgMtAMHQz55EK81ZqgjvQNxeoV;\
_ +XnQaY8zdeTPbyif4BbieKsVw98tJcXpyWI6QKRNKYNv6Y0YTQCdm5g6A9Nn8ayz2K0R3+0z;\
_ WApi40DUnHpANv57/8kT+OdXxL2kQvjK5lpEDtkJmaz2wdKT/ng+YVXy8Hn+k5eGcP5b2rnX;\
_ ceNCFkmi88f3v9K9SqjS8xnufvf/1fi3+384Sfv/TPv/WrXbtRtzAN6tmvakogQy1hEge0M5;\
_ pY3VFJvFfdtuvEtan8dZc8AASdk+Jwcxg17uyepOVVoUhw0Vc4e4pNVaLqWLGTll8d/oAwqF;\
_ /VvomMq2FY0ubYFLLihZWTeEAnWoJYWs5IAuMgJL6OF0f/Zh8fnRTvnHYYFDprT6FCsCvP8L;\
_ ygrv8wLoT9z/jK9mqf5/1vjzf/18Vd7DBdCfuP8ZTScp/g8V/8MFEEGnbQh4fXPP/D8an/L/;\
_ dJby/7PIo8C3f6DwV3gTzgbvFaE4UZX5uvOI6BpD0cB6s+W7gUbvSKuipD3wMVEx30DwnDti;\
_ 9FDIOToAkM5+rXecWpCtWMqTii+gdig2UHJxhEt6ApSkxKJdnfC49vk6fGU427aNVIqd5OTe;\
_ dsmSXm6l9rbacyXs0VO9Wj3j6mCOPa+sWGFP6k+0zOCt+Sjf/5mm+/+zxd8upfrI8r9w/5Pi;\
_ f8b4N7qS+b5n8n5x7vhP5vPT/G8yT/d/5+H/vw04+nZNvHhXKpCdVPyyUH9qEwJ7R0ZA5mLx;\
_ KnB9uE5DSgnyUBCMOQK/lhGyglhtWAlZcTkA1r7Whuia7xtsH95QGkDWGsNvQ4Q6Ad/GsXZ4;\
_ RWG5py5007SlhdtuVkbXwOWBuomvOejoC6UA+FY6GA1H6W4hSZIkSZIkSZIkSZIkSZIkSZIk;\
_ SZIkSZIkSZIkSZIkSZIkSZIkSZIkf135FamKBFYAUAAA;\
)|base64 -d|gzip -d|tar xvf -

#--------------------------------------------------------------------------#
RUN : Stage 2 ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA61X63MTNxD/bP8V25BJeMkXGyhtaNOhJXSYaUMn0OEDBEaWdHeqdZLQw7EH;\
_ 8793JZ3tJARKO/WM7/Ta9+q3e4NDeBGoC+ADbQRMoDYOdk+Pfzt+/OJ4OBALa3DzyfHPzx6f;\
_ vHt6+vzk5fHJkx+10VIH4SgLci6Gw8EhSC2RielEkJ3wED0+pGetMyZAMMClp1MlIFpOg/Cj;\
_ 4UDW8BrIAio/lbrK9ITmhehdldfW9GfDQWiFBm5nDeEoEnUiRBlGFb6d0LQTOKCcf0o8HED6;\
_ KQ3EQ94JLorrztUyW/KylR6MDdJomDpBZz7bhRaij5TyIJpDiNOoQ6w6irpINhsOkmqoArqP;\
_ CRK1p7Ug0gBRWWk4qriYVzoqBZOjvTHs7RW9vOBAJBAB+9XbGz+Yuj6CKzwqX914/RbObkNV;\
_ 7cOb3h78VSKwKnHPjxGrmxGvuGEz4Qi1gXgrBI8WVqtDNAwVmKKZPjhqL45RaS+Y0ZyUFFit;\
_ igTBWgM7rx6fnjw7+fUQjhcyJ0mIHmpnOvgCC/Tf7k87cLQ3QbmMegE765TaQTcOB38J76WA;\
_ W0USpuDSB9FxUAL96YECppC/C1FbymaAgmlDpcYwFGcyqsGJzsxRVBgVJr3/e5J1ILiwQnOM;\
_ +5y6ilHWigo9U1HHWswiX/ki+N3tEZqz0UY2LYSUBevwL/085+do9H9II4nfZZGnxRpM8u6S;\
_ ABtdIz7h3/PJgf3q01nqluQQnrd3gWoOtVxsLLzITn7JjnyaMONEb8gVS5JfMBU8mkQxfE6A;\
_ xnuMURU6SLy1STDyTTcn0d0cDgZRyS5hgIbxweR+0hSe5GSGJklFSIHx71BzTAzUBpiTGUYG;\
_ KdU76mZAI+IMef8edm9u1nxrzjuqI1W3+qONCPlkn0Abry0v7BeQuryGABZItI2jvOwkvfsM;\
_ fvQI7T9HGF3CLbgBr/JIer0fUi5LPcU7cE2k3iT2ylMSg0RcycN0FJTEl4maT/IZNe/GB4DP;\
_ SXqg17sOsak1warY5BOd4YWHZbIM0opC+EhhCsYo/zn5CHQhokkYpiQbuetaNoDQyL8nrfG4;\
_ 7HmH16/wTTR4xBsl1oqsp+gzuplkmRgk3EfPMXS1G2fizayc59oXxmLelQfRLLpUPupgAT0f;\
_ xCIUtyTyxiFGlqm0zsSQ3pkDoc5K3WymiExMWBpamCnT8OLJrWPTMHTj9O51TsOtrmmi/fjb;\
_ NV1WbTK6lzYalvcbPu3K3HZNXpFcj8vAs4drSqxTs1oqkTfUuRM+j3ozzx+kiWXUHoweboff;\
_ rakRgriSWtxPe1427M4dMh5NyAOG1yStRT8lB6MxwQMGvRNS5mZa356D8qYGlV0BGES1wKcm;\
_ fJpeNl/QjlPeYZJ2gvhoc7nPGRUcCVIvoYshgKbagMZ6g1miMSz4zzfEIMR43xKmJF7sTGgx;\
_ +bGoWWOjok6GZcoorPgBl3xIYNO/SUj5am2hsrZPPByZVExqsMvQYvqUV/K8E9ILdx/D3pRE;\
_ dCLpO8VL4PxSM/DFUB+5SZBW4h6Y5bGzEIRCCzIduqwk3Vx26b/O5PN7HSxqnwVcuNmcWivc;\
_ SvBmuapRh3TNN8UitQYbtMPKlHBuKqBYE53goy9gdAEhssXFpN3uzXJWwQro+Sx1BvL1n0/P;\
_ qg/WYdsFu5NHH/cvIo9NQTcZev4ow2uxZ4kKpv/q3ypkWcckJSyjSg7NFm8uxu3K5d+UzdKA;\
_ JJmpu0xisZhn8OEcG0UHVFzCns8DCkl3IJMKNZe+ZGg99RjXmtcq+hbfRbNr0QObUKttUe/K;\
_ 3VIGckOZrgSdCWzXoJu63v4eVG3KIxSGOiffbFIMB8gmLiBQP/OieK3Pt8Vcci6CYKH3Aebm;\
_ Zd/v7OJsZ72pxSayA+EpG256y01KJUos7Qh2672+y0x1MTsywY1HSmyw622ru6mKZ9h/YvN9;\
_ oSv75kfom7K896Ho8LWltbQVH3P7/As2cRoraGpmtl8ApWn/T11/UcV1l0y53N3/w3dBX+o/;\
_ 3/K/6D9+EAaswlhd/gr6G0aEvm8kDQAA;\
)|base64 -d|gzip -d>tmp/stage2
RUN : Extras and Cleanup ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA2WSzW7bMBCEz9JTTJQiAYJSjIucVDhA0PjQwu0hLtBDmwNNrmzWtKjwR4kQ;\
_ 591LWXGLuAQEUtydT7PazU7xw7qNcDY2CrV1+ELea4JoA1tRQEeuhzf2Edr7SHn2E8W7u9l8;\
_ drOYFZji95h+j7MzPOcZ0opGb3UAazC5/HCF3a7CrZUbcljpjjyix+QrauXfD1+BdJp8OUpJ;\
_ ri2ur7mzNvByKfzaySNenr3keXaakI+NsUJBJOO68UEYk849FNW6IYVWyI1YkR8tf/62+H4z;\
_ nxc4meL8/I3fQ6mxVSIQWP/2+sBmPQ6U0UOF4pMh0cBoH1IxUsg17e2s04V1fVnk2TH84QGM;\
_ DQImB21sweytdlU1C7KqFjY6SfMUnnJFHW+iMf8Ye0WeqXazSpDhzTHRCZ1S3BasBqcgecoe;\
_ nlLapi4Vv5yImMzQ1nbEUhMaMv5vficcN3rJByS/YNaoMeReY2Hb8guMWyp4l/6selXZ5CH0;\
_ LaHGCRg9kUQgwvMLfn3cN+horhIbxf/WCyzjqhx6lChP4NE7vtQNV54MyZAatdsdxuLI714v;\
_ lobyP+yRx/nGAgAA;\
)|base64 -d|gzip -d>tmp/stage3

#--------------------------------------------------------------------------#
FROM scratch AS stage2
COPY --from=unpack /opt/chroot /
ARG RELEASE
RUN sh -ex /tmp/stage2 && rm -f /tmp/stage2

ARG INSTALL
RUN sh -ex /tmp/stage3 && rm -f /tmp/stage3

#--------------------------------------------------------------------------#
# Finally squash all the layers.
FROM scratch
COPY --from=stage2 / /
WORKDIR /root
CMD ["bash"]
