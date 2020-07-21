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
#   jessie:devuan ascii beowulf chimaera ceres
# From Kali:
#   kali-dev kali-rolling kali-last-snapshot
# From PureOS:
#   amber
#
# The ARCH option can be set to i386 for most of these (and is defaulted to
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
# I'm using the base64 stuff to make things prettier :-)

#--------------------------------------------------------------------------#
FROM alpine AS unpack
WORKDIR /root
RUN : Configure host ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA+NMLMhWSExJUdDVzcvXTU5MzkhVSElNys8vKS4pSixQKEgtylFIzyzhAgBw;\
_ 6Nk8KQAAAA==;\
)|base64 -d|gzip -d>/tmp/install;sh -ex /tmp/install;rm -f /tmp/install
RUN : Configure debootstrap ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA61WXW/bNhR9ln7FhRdUbQaLyNC+2MmQIR9YUDQJ7PRpXgxaupYJy6JGUnbd;\
_ JP99lyLlSq43NMPyEpH3kufccz/oMBjARaUUFgZSnElptFG8hAXXMKuyMNCYQl9AHyHSDJOF;\
_ hMnR0+fx1fTi7tP93e3V7cP4xe33vjf0WASTMAD6Y5VWTC+4QtbCYfOqSIyQhQ7D4PJmdPYP;\
_ bjpRojTWaQDRCEsuFFziTPACvCnyVInne06hzHmVm+lKKCUVLIwpB4xxlSzEGuO0PhlLlTH3;\
_ uWN5Cr0josE2C8Sv2x782lnHv/TCYLXe3+uecRxvpekrXMslcfJEl7iFOZEppeFGRl1pzx8n;\
_ b8lBiSKbvIP4+HxyAkxR/My598kYZ2V2Hnk0t+3QvCCfZ1VhqkaQMLBg44vRzf0DiAI2XJkt;\
_ LCRXW/cdzyqRp6nb8oswSCW0eL0XlnKC01X6oUE+cnf2rG+BYZAX0J9ryCqjt94lI+ZrkqJb;\
_ PV7+SVzVRJnMU9IoR65RN3sNSMrLEpUL71p8aWLzV4CXSu8htEVkP1kJm/tqdl1CrFsk8XGb;\
_ z44kb7DaFdzAM+fU97To9EquMbXJ0jZbr0HfV+dVwH7/tZilVEb/34g2Zb9RXRW4wV1RNrqG;\
_ Ad8sd23mTuy6rF7ahqJujK7Pzk6eSsIwwwK/mOELdSj7itps3zF4cu1am6FH1Tyv8udE6pVI;\
_ nlOhE/nsPHsdv8NT4UAZxolc+YC7N/w3gbp3DId+fX12MgQblg/zJWpNl50W32nrFbU1FgaZ;\
_ MJDk1IfNBOvPwKczxTXmzbaNVVOw5B/nnIbuouRpXKDxtNnPWlbU6E0Unn0YJCX0OXR3v8V8;\
_ bMM7qEbcnkwkdqKQGwSzQJqH6+rb4I5diZ5CHacWKZWDGwHOrYnLNvjgsUlAfDz4t1y4s4dy;\
_ MYjaN9J8O1wU9C7E7pL6mVihyjCNwt208+RqolwnQhy0zFBuqnx+0EbMVhwVP2xEhe6182Lt;\
_ Z7udzxZP99mEvwtbmCaRXcuPJ/K+Ung39jlrNAOh4feHh/txGPxh5XSlylczmtzwJ7x544TO;\
_ FBL2X7Xgjwfk1lH3pD3XHlsnAqpCo4HLq+tpjTf9dDMa3Y2652qeH3ku6h8vpFl9NzigDsMl;\
_ ObUJ/hgWlU2we6u7Yeye7CYt9n9sYeqs2I9zd0GLQM23N5YrBBpB+4MS6HGNDFGzPcOJj0yW;\
_ NE5taESvKoGVSib7T+zktDZOrY0NoLWIXGFhmm1fe2aOgmZp+DcBDVrhKwoAAA==;\
)|base64 -d|gzip -d>/tmp/install;sh -ex /tmp/install;rm -f /tmp/install

RUN : Stage 1 ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA81Z628bNxL/bP8VzMYXNc6uZNlpHi4UwE0MnIHmASc9HNDeFRTJlRhxyQ3J;\
_ laxE/t9vhuTqYa2bfiouiPdFznA485sHRwfnJPvo6USQISmNJUfXl79cXny8JEcX16//mZGj;\
_ j58u3n44PDx4c3U9GjTODtyUWjHgYmyMd97SeuCYlbV3hweMOkGylkVGpD48qI2n3qwWxvDl;\
_ ylELKz0myHuUHX3D+3khz148u83ITz/BMsKz6UoJrWHyl0aIr2K1mMJtSR4fHhD4J0vyG6wR;\
_ pXswIkhM/hPH/FTAigcTK2pSfCFzt3SMKkUGtTVscHQ0qGjtyGpFvsEsJBBsasirR6cku7y+;\
_ fn99Tt6IsaR6owUrvjTSCoesN/wqURm7JE4wL43uZ3vcLjhfzx6JqlHUCwLaXX/T1Mu5IN6Q;\
_ mbBaKMJMVVHNiZJadDFUHuYFIrUkDagZBQp7p5ZNpQdRGrtFeSM9OT2Ft9uomlLGe1Dyglq/;\
_ XE0NtcvV2KJ2V5zWtbArwSfLVSmkg/FJ4x3MohYMJ7UHpUq++kwbDWMzaivJ/h6b/DqGJZv/;\
_ G5vcp9kdJXTqoMs9tm2B6gzzkc8PjPqkJBBwMK8GIEz9RyX1H5Rz+zgjxcSTpycvYRXy6FFQ;\
_ 38F3daeF4O5P2Ga7XKzgDRMcdRJWMjoofWqcJ6iZOXeGcOnoWAkeaYN6ztJGQEUHwlHWgcHj;\
_ 8+MWPrjdN5c/f3x9ffXhE+qu1wt7AuLfSIEqg+AzOPqWNvHw4fE5hIs0AxmsiTGm7Mw6bFd4;\
_ sM1oPf+8WM//x/nx7Yar0qQoHXGS/wWi7V1BcHtIrkqiDXENm5IYG3MyaYRzRPqeAzjNQBRg;\
_ nf2twiVD7IZeWvFnT3HS1bvXl//+dH0x6vVgG4Dl1mF7/52JpZV60j9uAph6nYumNZEVop28;\
_ fv/2wygrCvCh2mihvRtVVOoc/NZbybzgeaPB3awTOfiij49ALRQ4yX3UzEAckuNcG12UELhg;\
_ PoDq8AAR9K+L66uLd9v4QZ/AzW+2MqcWwrt3/WMA/Bjc8TubifpOnEdZIoJVb9Oi39LYeZHG;\
_ bnH99LwjRIfzx4HtBBkiwEPyaSodxHWhez54LHggepszlcDPEOucW6JTWgh6c9HfEMF/LaiF;\
_ HEFbKXIybsBb6+ixWvggWuKeASdQr6QqewBcEgSKQtww1XAxqsY2rwwHvZd5zWTjpXLwUDFJ;\
_ C+ZwKH5SUpnemkF2FO55Xdf4ZwRekYecxPfADy7OKFF4Y5TL9oh3hgslxy6H4FLlzBqdU58D;\
_ INRNrszEogLFPgMgkRw2hw8K8ttpeDBsVkolhvhSM1qfxAcrzvY5QIScwQI8j9cybZZPWV0w;\
_ JZG3E94Ji/rrWt8KyjF7PMUXR516jjzhS3MD8s/AsvP7N86ppzkaq0iqgwANmd/mnrqZEx0r;\
_ UpGXY5AIJC1V46Z53VR1DuG51nVQY34zl5wLrBb2qb1QGml9nU+E9+LGFwE/Qs2lK7zUS6QJ;\
_ YQ5x+xmgI0VA7B5sYJNeVDxP9wLu8314UKbWe+IVyN3UqCeWTIX3Yix1p2aZXULJiSRBt6DI;\
_ KlQww/7JaT8YdwbgPO2k1ayBWOMWPwbTQyqs3Rk+guTzYd4ko2wiIkovtfRgByt62zq4m7zT;\
_ UhtFtNujytGozfAUcQQg3jLvvqiwd/6ywGSbjx3HABjpWoBgfWL0dwC040Y5q6UBD6JV6WDj;\
_ ky63Q/fi48YVwwD0sxbp6SWsmUPOZxB57HCfwXoort8almuXvMe40t3j85AVxGcAZw7mdOFS;\
_ JGOtnQ+dFzG6T7wD2olu6kkOsaEs44cpr6FmzafG16rpULaEfKJpJeChqblZ6Fzq0uRod8uT;\
_ 9iTorOkKNZDisQTCGUHKAs5FTNTUT/PPZdp3iCGdeKTONJoHzFNfBfCOv54WAOWA9GjAgPLx;\
_ 0343pLfxH6jWVggv2g2f4UPQ6Gn/rJOHuAGBw/zSYuiUgdGEDeMNHe55J+GEj6vgQKB0r9ww;\
_ 0tWTQlhrbHqrJsN7QrQehhVA4Ofhvjh93h2yO+nVAkqKwEB9NeFe0YmMQq8dvZPS1EIzPnsR;\
_ ogA4suDD/rPiZJ0Y+s83jy/uCe8SnLt0J/2zSIchPsjs5IQ9eQImPC1+ZMOTbqM5p076L+My;\
_ ENP1sAi0jRsXJ/1hEQLbAg7YJx3UbdrLlZsu4GLKXAXQ5WpetV4Kj2iMedWxfkyfcL4p+Bhv;\
_ NZ0AfitOeZVXUhZc0gk8VKJwDaRs25EwMPtDZAmhMTpI5W1IFFDSeZ9rqk0OKQVOMvvE8H0G;\
_ dJAcPc815Bz447ghNItz0zbsRMvs02+qEVPDWc5Kv8RA6qG+hE/Ol/KmvRe+K9ak4mSvLKld;\
_ BVDM66WfggrjrdNlovWfhjiat1Bo31Bj42aSW7fUrKOyiLZyDTebKsOzOl4wa6ds7MEC++Sx;\
_ Eo+BDfNVDpiJ2phDhQR/LQIWZ9U+9QIiZb6AIzRELJcsd5NE7+3k+P2uQHe+RwikLlDK+QVo;\
_ Yy4ZQCrJCtWorKjarwKa2nmwcaj1qcdSIRWYKUmu8+WfYGA3iG6HL5jSBf4W4He0sKgpol1J;\
_ BqeEjvpqncXvZNW/mJBjJlzTCgtKadxWkO/IiH6Ka6y1FIByMxvH5Bps35YnHWkJkxfm+iTn;\
_ 3KimEpK3FWR7D8w6UNaCCmPVErJ20G7L5AQyGgh+n21CkVsEo0SV7UWLLq+ALTZ1EcTKb4bD;\
_ Fsa7hXh2H4ZC2YdC3V+5dGg4FBwKDkimLmJtnNLQCyhe4ATBDO8wDB4qIeXuFFs7vrPVPvu+;\
_ 0+w7wfyuI+0UnvEsj6fQrqbSztJkU8hCTp73Qi+gu5+3Ug2DbxWFwkGy2UpT7+/hcHhAHZNy;\
_ NRZm0ahyxabg3cLSFROQj1fH54DMhuod4vipSP2EKMiMKlkc70wLn0JXcy52J9NqLOzO3Lqx;\
_ wri7s2P119t0PeJhvSXDh19+fXMZepV3egXb89bjjx6lz3epto8JG7o8NV06htZM7s4owDEi;\
_ LDbLb9oMW70NLkraKB+FbjsToWmz1ZInRVHCWUVONEmdnidFUNIoNShvye9Rgk0HA2ak9sho;\
_ s+BmHrZkCLbp3n/4dPX+3UcS/YCsxW1nZjsNqIywqQWx4PPbK+xJZjvNPhD7B8bTnAKgz6a4;\
_ L/AFwkpSkP5jsiKbGe3YDY49RvRzMjC1H8ThpK21L4zaQ+q2hfEHj3gsxW5JA4UPg4M4waN6;\
_ 6KlIDa6oFBFzobGpuxCEG+yVLEA1RPp+tuFjCB7xZ6EpmiQMXT8/pTgVCIVDUsp8AzyXBDJv;\
_ u4DgLScHyxcSe4C9QTox//6qfzzgPbL9M0vqe/MIi9CkhZId6gySNjzKeu3eexl5RXyFREpA;\
_ hEjzAWa7NtxAPc1HbWAlCCtUczLATw5/HjrGUfi49XMRxioF8XLnd6Ps8H9Dwmt/UhoAAA==;\
)|base64 -d|gzip -d>/tmp/stage1
RUN : Stage 2 ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA61WbW/bNhD+LP+KqxPEcRFJbbABhbNkyBq3SJG5Q5qgH7K0oMmTzVkiVZJK;\
_ 4sX57ztSsiK3QTAM8webJo/3+txzjJyu+BxSV5SpwRyZxV6UfPffFBBnm3u9aAT9T44ZB9ax;\
_ GcI+ZNrA9vn4bHz8adwnAbwrNR2fjH87PZ58fXf+cXIxnpwcKq2kcmgYd/KmVjSQSpIeXaCT;\
_ BVqoLH1Jy+dGawdOg5CWTXOEqhTMoU1gF2dwO0f8ezkc9CKZwRXEd5BW1qRTqdL27vXOzhW8;\
_ gPjsqbNe5OaoQJSLWSzIF3I2jnPNWU6/BhUrkBZMiCcu7x+lAm9SVeU57Oz0IvCfXEFsIQg6;\
_ U+GP13pRJkPEF3NpQZdOagVTg2xB/3IB5IOlLfqTBbd6kf8mJyi3HONKWZZhLDXtlIayGDPD;\
_ 59Ihd5XBJ32yKCCWECMM0i9bv+gsO4LvlKU23br6AtcvIU0H8GcTC31SdDz1DoSvhGezRKRC;\
_ 8wWamJUutiWiqEpYrUYU1BYFhWC5kaWDUueSL2PDE0GF9AUVMF2CwCllwTrDyl5U3NQJsj5D;\
_ 3QtP7sa1YTKUdrR015QUi1wrEdeIXK3qUJDPNfQ/H59PTifvRzC+kwGzrrKQGV3AMyrI9e1f;\
_ +3C0sx8CPFW0Tcnl2hjKeb5MelENyZjlBGnFPKQtaZGN5NMBdtdNvp+LGX5+ReY5tR302wYD;\
_ qXrRX2itRBjWOkbwaWkdFgKoR70fDKib7B5UqmR8ARQ3mzGpqNMCuoAzBQYLfUORuqRW0gCu;\
_ ubJGnsASlSBs3zCTcsbnmBIC0gA/spTa2vDXlwlls/VGzubgPNIbiJPUTWj1JPk/rMVe36bJ;\
_ 8zoa6utiw0BZmRn+oL/REwD8r6WD1ccrI/g43wOmBGTyro2wq04+F0eQjglQ2A1kC060Grim;\
_ OMLHA7UbTHFJlV2ie1GLHhx4qhWz5SpDad2yAwbiU/B5JSRbX2tFvDVFQq/K5IwIQyTPRF2b;\
_ jgk/qJwkSiSgRtu7tWwOK2C3C88p8ury3XV6H+gItvcPHgbDx+T4wWFociQ1+bX+lpr6Tz+6;\
_ epzn+vYRHnREfhpsugjFHkwr104Bg9YPnsb7J0k3sHjdT4/lCKZzVGq5st8qGh5t51BrU2+U;\
_ JTJjIUiEiq6lNnJHLnJfEg1ypqhuaw2+RjTypPGHfow5VpRA/O4PFrhM4KRDNEJSUNSHp5O3;\
_ Z5cn48O1lrZet5Logyyyyg8pJzmxzLpggdEGx39cjEbv0Y1GIX2XakMU+j4b/YPA6NFRTeYB;\
_ faVLPASIyym/yAkIVOxSW+m0WRKWLOO9dvC0YPEAIfxJ1Q6lvAYO6YMpcVOcyRwt3bwKj4X1;\
_ 6PODomBmAdc0k+C+DqDdJJdpmH37Btu77Z6d69uCqYrlw+ZKo9K/P9r8BHW7dOb1VbksCDex;\
_ gtf7bzz8qH8Cc84CHxPTv/4dMkFU+KFmTJpS9Ixoblv0g59coMRtWhk2Ev5pI5u10LRYs7Gs;\
_ eTiKPOXzvBJ4+NKDKtoMsw4nVMI3UT2Rtu/l1uO1hz6snIE9GMC6g6I1amkVqrJ2QBHooga6;\
_ D73oISS9MxoOoRkM3ZxvrcmxTaGbU7y3SLVtG40QxxlN65YaHSVKtBCnvmSeJGiGVPSKu5GP;\
_ mPSl+O9l8JmaURk8HpqJ1BLSsnNeT9vNPaIFF1flzDBRn3h3hr2105+1WTCjK8/QVMbG8voy;\
_ DSd6dC3BegKS1lbYabGjo9QTV5oQvueGd2H2av+nOvFkAOGWEfldXryL3+wBPUZtVfqnb8jN;\
_ fbdlfZV2z44n7w/fJkEcAlFRIubMFEQLnSfc0NexFqJX7KCrJqzq13VXGck8kM+w4XT7Ug9v;\
_ dK6LMkfK4OZj/R/q+ARKBgwAAA==;\
)|base64 -d|gzip -d>/tmp/stage2
RUN : Extras and Cleanup ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA32SQW+bQBCFz/ArXkgUt5ZhkytVLFVND5WsqlKi9pBW1bI7BmS8S5bFiRX8;\
_ 3zuAnSZuVCSEmJk379vZCe4QnX35enP7cbGIcHKFGL9wfo6nMAA/p7ilxsMX0kPWHmWDB+tW;\
_ pcnHPMfinDzaWktPiLevw6VpvKwqjkOr1ylHa7thRVy3Lqd9xcH02j6YykoNafRzE2m4hpal;\
_ IY1aqpXMqRkFx2eYTIZDhEHwBsjZO1KFfano4B1mmGDyPgx2DJEi+lSRNKjKxjczKKkKGlgK;\
_ Dli3TaIwOD76/T0fphfEqte2NWJ7Xbo0/exVmt7Y1ilacPpKaNoI0zJN1438bo3YLSE20omq;\
_ zAS3FoO1mP71GbqGga5XORv1fy6WG1lWYdDrWU5eDVJ+E2XNMtHi4lK2DDzMOl6RM1Q1z/UH;\
_ u76lmMa20mPqgOLXtZhi/PBQOh693qssM/htTVjiBDE9koInwtMOPz/wAE+xkBkx2R0nRzBN;\
_ WSnNb1U4az1fT9dhuAdtFXNh/kbV0OgHr5t0tmXrpXVgSET/ziBC1uZJX39tDcEa1NZLb2e8;\
_ rlZvZ2hkv2X9FbJNkfRkDP4I0TZOZKURuqGK1J5sv/0D4Ldx1VIMrvOjsQ3uMqvoheI7uaa0;\
_ JsVFcon5fxS78A+fUtEyfwMAAA==;\
)|base64 -d|gzip -d>/tmp/stage3

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

#--------------------------------------------------------------------------#
# Patch apt and dpkg for docker
# Note: standard used "#" for comment not "//"
WORKDIR /opt/chroot-patch
RUN set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA+1abW/bOBLOZ/+KOWXRtIUtv8VOzy0KdDe7hwB3i6LtYr8csKClscSzRKok;\
_ Fde97n/fGVJO3LTZw+5dnB7KQdrE1mg44nCeZzgUumx4dMcyIjmbzfxvkpu//d/j6Xw0HY9O;\
_ z/j78Wg6GR/B7OgA0lonDMCR0dr9nt5/uv5/KkjxF40bflnxH49Hsxj/Q8af/qWZVqs0H34B;\
_ 8Z+Opmcx/vcU/1xnazQD0TptsNaXOLBtUaB19r+I//z09Lb4j6dn84/jPxlN5vMjGMX437kM;\
_ h/Baqgzh3EcdWovGgjAIldZrqQpYaQOuRLC1qCpaBdBoa+WyQlhJJSqQtaDF0WedHllb6arS;\
_ G74RazR0BQT9wCWaLWS6rrWCRjiHRi16rA/w6qcfgZbfoEAHbZMLh/DPcIXlwYOri1JRrKoK;\
_ Blt41ohszeM+v6H7LNdgdY08ViMr4SQNuNFm/fwWo01LTrLJgV/xg7Dk9wbwXn67hRxXoq1c;\
_ H168fAMbSX6IzLXkzxZ+WSM2v8Dulp2jmMOlFPAK+blR5Ra0YWPn2PhPcgVCaZo3s7sVXneZ;\
_ xrNZ9wEvUZFOThazqs15VukmjkZ3A5tzpXBkWRYcDvImExTE3FsAp2GJe/5IC+EB8xTgNTrH;\
_ Jl1JXzvNtpKVqCwmgMq2Bm2wzQ9MGqJpjG6MpADRKKIoSMFKmiux1K0LdoM579b1bDgQeU4j;\
_ +pksnWvsYsiAI12bYyoqSXOQ5riUQqXaFAxAQ1TDrBxN7GhGP2np6uqY4UkWLyhuLyhQrwI0;\
_ 7Sbsom60cUK5HiksFtcai8UnKrunfNo7+urldvzPKhTqf8b/v4P/k8np9Ab/z6bjScT/g+I/;\
_ w3ytCd73iaB/BUwdhFgoCQYIlKSCJCwUWLayyhOwDhvbD4CEWyBsQOWkR6QlIyDbyOWlzAkz;\
_ oRJb5pm8RYYoBrSN2O6GLgnxiGnYlNcjUCEotA1mwVxrGWa+0z8TA5HelkauLeHZzwxWHsxq;\
_ WrrWP1JrGboYxjrPCB6zch/ZGLstAV5O5AP/ouVArliPi5Yenr0mXW2x87kPtWBeZHO6Nbsn;\
_ aZXCjJ5ZGEkeVoJJ5eGez9ZP8gZPiDeUNrX/UhG++5nufLNX3olCyID8nml49lHkwb0b836t;\
_ So4RGMPS0Ae2qHAT2PlRgN6LHHnYfjfURrdVZ9JzxGXg+2THjB4Akj6Nw9TrH9ahn5n+Fe3Q;\
_ tKGfuCXyvdk2q2QW/EYotKNV0WZrIA6mqT6xVFRk6z4RtL+MXbRWrWKDmcFA12yZdPdXUHjw;\
_ jz1Le+cv18Vi8ZJW7eCC3Uf4NySmhsEKhpfCDP1kBngzWUlUZYePmWhuvdoIwwN+XutxuqRp;\
_ +PABnGmJPODXpz16qMXiJ1+z3KsfvXNpFovvWGWxaNaFV4aEGG7/gjXZR9d40n/UVG75UFJE;\
_ qHaiGFTyPYbASKtOnE8ayUvH5yila6795b6PM5eKoqIrPl81Y4MvOrjEg27jQEG18HDH/IV0;\
_ ZbsktqmH9HQtGoPabRu88Ula26KlpRtJ+l74v3gvmwFBNr5De6f8Pzqb3dz/z+e8/4/8f1/7;\
_ v8CwyWd2Zp/fjqVpmtDnjsak6ax5eia4YBQpCDewQo82xKWSNznhulgRVGyEyQlRNlwIKLfb;\
_ vLBB4ibaQfrdJ/9xtfvUapBLe8Um+K4h6pGOyMLg25Y3qoHiG+cp3pv0NEMbQ965EG91Jmgg;\
_ fUWxekV+7nS67Uwd+PMHqif4CnG81Yrh75qSwvQkoRwg0qaSoe3ojRhNAO2bmDo90ydhr7PY;\
_ lIjvtwksBbGxJ2ouPSCZ/DV98gT+8S1xL6kQvrK5DpF9dUImq6239CSdnE1ZlTx8kb1tpSGc;\
_ /xtl7kVIXEgCSfT+eP4rPaiEKlrew91t/p9OPs3/0TTm/4Hy/0J16doPNQBnq6acVFRAhj4C;\
_ JG+oprShm2KTkLdd4p3Q+tyvmj0GSKr2uTgIFfRyS1Y3qtIi3yVUqB3CklalXEoXKnKq4n/Q;\
_ OxTy+ZvrUMp2HY0+pcAJN5SsrBtCgdr3knxVskMXGYDFj3AzP1NYPNrLlL/vFjgkSquvsSPA;\
_ +Z9TVXiXB0B/4vxncjqP/f+Dxp//S7NVcQcHQH/i/Gc8m8b431f8dwdABJ22IeBtmzvm//Hk;\
_ Jv/P5rH+P4gce779A42/vDV+b/BRE4oLVZmVvWOia/RNA9uaSz4baPSGtCoq2j0fExXzCQTP;\
_ uSNG942cvQ0A6WxLveHSgmyFVp5UfAC1QbGGgpsj3NIToCQVFt3qhId1m5X+K8PVtm2kUuwk;\
_ F/e2T5b08lLq1lZb7oQdP9Or1XPuDmY4aJUVKxxI/ZW2GVprvsj3f2bx/P9g8bdLqb6w+s+f;\
_ /8T4HzD+ja5kth2YLM0PHf/52Sf13zS+/3Eg/v/LkKNvS+LF20qB5EbHL/H9p64gsLdUBGQu;\
_ NK881/vjNKSSIPMNwVAj8GsZvioI3YaVkBW3A6Bsa22Irvm8wabwhsoAstYYfhvC9wn4NI61;\
_ /SsKyy0NoZumay1cD7MyugZuD9RNeM1BB1+oBMi445Z8M/ZNy8GAu5HwqMdvhmBWanj+YALJ;\
_ 9/zKCpUg/M4F+YxKUsFCg4VESROv/vQp3f62leg+nJx0Jui7x/Boz9K5v3cBw88lG3zz+MoU;\
_ WpH18J10MB6N4ZhfMOHzMKpUljInD66Hj4ciUaJEiRIlSpQoUaJEiRIlSpQoUaJEiRIlSpQo;\
_ UaJEiRIlSpQoUaJEOfoNr32PIABQAAA=;\
)|base64 -d|gzip -d|tar xf -

WORKDIR /opt

#--------------------------------------------------------------------------#

ARG RELEASE=amber
ARG ARCH=i386
ARG MIRROR
ARG VARIANT
ARG DEBSCRIPT
ARG DEBOPTIONS
ARG INCLUDE

RUN sh -ex /tmp/stage1 && rm -f /tmp/stage1

#--------------------------------------------------------------------------#
FROM scratch AS stage2
COPY --from=unpack /opt/chroot /
RUN sh -ex /tmp/stage2 && rm -f /tmp/stage2

ARG INSTALL
RUN sh -ex /tmp/stage3 && rm -f /tmp/stage3

#--------------------------------------------------------------------------#
# Finally remove all the *.deb files.
FROM scratch
COPY --from=stage2 / /

WORKDIR /root
CMD ["bash"]
