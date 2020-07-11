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
