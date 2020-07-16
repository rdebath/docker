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
_ H4sIAAAAAAACA81WbW/bNhD+bP+KqyrES2ZFW1oUWzoXcBMDM9C8wE6GAc0W0OLZZi2RKkk5;\
_ 9aL89x0pOZYbp/02rEDBWLw3Pnf33LWOIRhbNkP4GaZKQzgafBj0xwMI+6OT3yEcX/XPLoN2;\
_ u3U6HPXiwujYzJnGmONEKWusZnlsEi1ya9qthBmEYG0iACHbrVxZZlV5pxRflYZp8rQPznYv;\
_ CO/deRyJV7+8eQjg7VtygzaZlylKScKfC8R/sLyb07GC/XYL6J+Ywkfy4TQDeNEDpwx/VXd2;\
_ juSxNdOYQ/QZlmZlEpamEOdaJXEYxhnLDZQl3JOUU8BkruDd3hEEg9HoYnQMpzgRTG5Q0Pi5;\
_ EBqNM72xl2Gm9AoMJlYoeRg8sdbn/FG6h1mRMotA6D5+k8yKJYJVsEAtMYVEZRmTHFIhcZfB;\
_ 1JKcV0pXUBDMLiD/dqaTubAUSqEbml+EhaMj+vVQQTMV1elBvmParsq5YnpVTrRDt+Qsz1GX;\
_ yGercorC0P2ssIakmKbECWkJVMHLT6yQdLdgOhPJf5OT6wm5LP43OXkO2S0QdmKwqz2auXBw;\
_ enln54eE2RokCjBeZjEFk99mQt4yzvV+ANHMwuuffiUvsLfn4Wt9FzuJyM03zAbbVjTyIkHu;\
_ MPGelPSgz5Wx4JBZcqOAC8MmKfJK18Pzqn4IQdRCw5IdNXhANPAShlOQCkyRzKFikS7MCjQG;\
_ hO0YAn5BgBnhTFe4vIDIQUhkFIf3p4P345PR8PLqOFo/kGjEoUFuUwnR1AApf1v+MaQ60G1q;\
_ Yhl/8/rB8R+ld13Dnb8XuNJCzg4PCo9v53suXAHAycXZZS+IIiqrXEmU1vQyJmSXStlqkVjk;\
_ 3UJSBWqDXSpPW/1J2phS3TynnShqTTHpSiWjKfUyyRPO7dYm2CXTxGnWHB5QlidUg98J1+Pn;\
_ QPmjPxr2z6+c19pGr7bgAHkJZwWVAX5J0oJjLKQ/XanM0FUHFJKzjCYLB6o0i9nu+fCJsi3c;\
_ TBj8eTXq9zpRVFvsVVq8W58RnUuIotqRu14KKSwhoulJLoNf9ZJ7wxOr9H/ZrdIWeTAaNVmR;\
_ 4LdVnct64HXXIbgkGJViZJVKzeMvxx9KPuesQa/Pemw6K3Jj6X2+AJj1aNTQRAb1UiRoOk0z;\
_ QehPCDobzGb5bNmMYTetl2mR0LeMUQGKZFESMdqnMT5nk5lEiHKC6q5IpyXNpoyhZmWCjrL3;\
_ n+oTqAWTUd1SVSIXLBXRwS5pf+NH3hK3dXz7Ug43iwkVC600KGZEBV6nVy81dWFD6JoKQuqC;\
_ i8ur4cX5GG6qh9TQhffD85MP16eD4x+DTQhh/TF4WIs3SjqZa3IP4dnQEbC3XXUYhZZwiFVu;\
_ 40qGPtC+oRIaNjBnBliqkXE3wWyRVxTdbhnqnkg40uuY+OY3f3fr2fsYGj86sLWPFbQPRFXd;\
_ kJePzfh6UC1kj0PDxf8STgqtiVOaZnxQk2JWiWwF4gfETXh/PR7cOggvzgfnV+OH6nvw9CL4;\
_ KsBpIf2UppXx4WmANSM0A3RLasUCIAwRS84INg4VYPQYIak3aAnAJfEsMfUdAleyY+GOSItm;\
_ yWGwsaOAVh628IOszpafP3bOnCgponGqjDYqsrnydFY7QL621MAjrgnq5t3hQcy3X1rvKrx6;\
_ qMcHv+RKW6gf3As667d3AngHNnNKKRJZ+AJZ7+au61OkjaW5pLf/BTHIfZm+CwAA;\
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
_ H4sIAAAAAAACA61XbY8bNRD+nPyK4e7UF6izTShvVzhU1AOB4EAF1A+lIMf27pp4bdf25kUc;\
_ /50ZezeXtNcKJCJl11577Hl55vF4MoMqdb4Kyige1XRyDj8nHhLExBsFC6hdgLNnl99fPvn5;\
_ cjoJHbD6WGI6UVvvUOLp5VffPrn64+tnP179cnn19AvrrLZJBS6SXtO8c9BW48quU0l3KkIf;\
_ 8aGjaINzCZIDqSNfGgW9lzypOJtOdA0vgG2hikttqyzPeP7Qx1Dlb6P8y+kktcqC9KuGSdwS;\
_ dWLMOMENvoOyvFPY4FK+KTydAP2MBRYhj6TQq9vm1Tpb8kurIziftLOwDIqvYrYLLUTHGRNB;\
_ NefQL3ub+qrjqIsWq+mEVEMV0KdCsd5GXiumHTCTlYaLSqp1ZXtjYHFxZw537hS9opLANDAF;\
_ d6vfTz93dX0Br61Rxer0xe/w8n2oqrvw22AP/iqVREWr58dM1M1MVtKJlQqM+8SiV0r2Hq6v;\
_ z9GwUzRMQRRB+wTeGS12LIiZhA2PIFXUjUVdCBNSLdEfMQXup5NuXVyVg3QoduvXvDluVh2s;\
_ cdhGD0UlnJWsgPD6upijROvg5PmTZ1ffXn1zDpdbnWGa+gh1cB28YwkM1tmXJ3BxZzF9u7ZZ;\
_ r9uHUEog2OFkTIUTjPR08qeKUSu4X/TD1NnFpDoJmBlrhDYHRHl8AL31XKwA1eUN1xaRUuIt;\
_ uIWgOrdGBdOsLDJAZBAZsSKVV1YiNNc8VIKLVlUYvIoH0SLQYxXLxn+8P0Mn7LXRTQuJgDoi;\
_ dBfXOYVms/9jN0brHW/5rFiDedgdbeD70Kg31h/Wydj717Pzrjci5/Bj+wC4RVTq7d7Cw+X0;\
_ u+zIs5lwQQ2GvGYJ+QUBFNEkjuELCixSDUZV2aSRWGhjXJeSm+TuTSeT3uiOaMrC/OHiEWkK;\
_ Twu0GtoVWQ/mP0AtERioDWCuZaabUDZ2PKyA90iF7NUrOLu3/xZbt+m47bm5P0xtVMozBwDt;\
_ vbY7GC88evwNOTax3jeByzJCeg8IfvwY7d8g/e/gPpzC89zS0d5NhGVtl/mIeCNSv9HyJnLW;\
_ J43Ul5s0FYzGl+utXOQ5Zt3NHwI+F/RAr3cd0mfrkjd9k2d0TpY1vNClQV8MMhyFKTln4tv2;\
_ Ry5OPZqEYaK9cXVb6wYwkeVnrHURP0fZYfqVdUkGp0Rn1KjI2EWf8X0n74lBwnH0nEBXh3kW;\
_ 3vfKfGljWVitu/JgVvSBTrg6eUDPJ7VNxS0k3gSk8dLVPrg+0TuvwHjw2jb7LvKZUJ6nFlbG;\
_ NbJ48sax1EzdnN6DztS80ZU6Ns4/HuWyaovZhzTQiDzeyGVX+r5r8hct7bw0ovhklMSjdFVr;\
_ o/KA2QQVc2swc/MRdbzg/uHsk5vmp6M0UpA02qpHNIYHifjgAzafLdhHAtOEvvVxyR7O5gwn;\
_ OPROIuRm2dhuwERXg8muAAyi2eLTMrmkl88J2kkuOwRpp1jsfa5IMqJSYEnbHXR9SmC5dWDx;\
_ SESUWAwL/nOGOKSYGFsmjMbEzoIewY9nnXe+NzzotCNEYVFC52JMRDbDmyXCq/dFyvsBeNhy;\
_ dATV4HepRfiUF3k+KB1VeIRhbwoQgyJ9l5gEIe6sgFgMjb10RGkl7kl42XcekjJoQZZDlxXQ;\
_ rXVH/xHJmw872NYxb3CQ2ZJ7r8K1ks3uukYdKM33hwVVL3u2w5OJeG6poFjTByVn7+DoQkLs;\
_ hhdJu7N7Za6Ba+CbFRUv+sWvX7+s/vIBK0M4Wzz+++4h83gKuht1OoWfSv81AnoAaHSmTiJf;\
_ dEVOIqRmmnWyV+HkvbLMDs2h//V/Vd+LTmjOROagHMgbdjqM8jFVDAcIlUi0E572mZ2kxGI3;\
_ AFdH5PR2xmGUJFlUmbWOBcL1MmLga1mbPrb4LsrcSi9YSHvrC3m9lnzGQS6KKWf4SmHJCd0y;\
_ DCYPrOsJaLgZ6kzu2GMQG7hMv4XE4yqq4qgBkNu1llIlJdLgAwTvsbtPzrB3Mg5aNcb5iTFu;\
_ c1OdYMgReJgkpZZWskR8vBwg79ANZYDjrSV7tu/myrCH2ERFLqb7OnyPbdIQawxk3XFsqMgJ;\
_ ZTlgxHsU2xf5/jNeC/bH80us1fGiclAevvcFDNVhHvur6PBvz/hS3/ydK/LnLqx4ILLPqPqu;\
_ rDoe51jdIc3vIJILdYy9IiUPFDnS46CQvrio6EZTzdC+Ngg4Llumw00w3wGRVbzByB5fBv8B;\
_ WHXy1TsOAAA=;\
)|base64 -d|gzip -d>tmp/stage2
RUN : Extras and Cleanup ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA21STW/UMBA9x79imkUtVHgN16BdqWo5IEVwKBIHqJBjT3at9dqp44RG3f53;\
_ xkmWwtJIkT9m3pvneZMt4Mb/ctZLDdJpMK6N0lraD6CxNg41NFLt5AZbln2H/NWnz7dfr8oy;\
_ h7MVXFzAHZyfwyPLgD7ZRL7BCF2jZUTgw7/XR24+wJGFZU+MZQXk1xalA2va2L4FJdUWRzlb;\
_ uvBhWOYsOyW/vwfOE4CrhO0a4P7GhKL4GFVR3PouKCwpvBIae+E6a585RgTLdLPbEEk6BS57;\
_ aSgl7IHXIDAqQdnpXyrv6qUW797LjsTg3vfIdxgc2vZPfi+DsKYSiVJccm/1FApzLO4bcQnT;\
_ Qg8+UGf1jPKkIQ4NQg1nwPEBFUREeHyCHx+oOQsoZYU2NZ/jJExjZaT7qbbB+0gOHA6AautB;\
_ e0W6YP1C1kj0zYedDL6j0rUPQCIh/78HOVTdZpnqkZwHEF0bRGWc0C1aVH/XW69PHj7iZWWR;\
_ sQW5OplKzkSy07SzXm16DHFJGaaGNFGvE5ZP17On88g9Fz+i3+SwgvLL9VUJd8RAxI6WNGWz;\
_ EaeAOXpSwitJc8gDOrnHcZNcfRFdG/YbYIxA+yUDAAA=;\
)|base64 -d|gzip -d>tmp/stage3

#--------------------------------------------------------------------------#
FROM scratch AS stage2
COPY --from=unpack /opt/chroot /
RUN sh -ex /tmp/stage2 && rm -f /tmp/stage2

ARG INSTALL
RUN sh -ex /tmp/stage3 && rm -f /tmp/stage3

#--------------------------------------------------------------------------#
# Finally squash the layers.
FROM scratch
COPY --from=stage2 / /
WORKDIR /root
CMD ["bash"]
