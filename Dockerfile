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
_ H4sIAAAAAAACA81Z62/bOBL/nPwVrJqrr1nJjpNsH1m4QK4NcAG2D6TdwwG7dwuapGzWFKmS;\
_ lB23zv9+MyTlR6xs99PiisaSJc6DM795cHxwQbKPnk4EGZLSWHJ0c/Xz1eXHK3J0efP6nxk5;\
_ +vjp8u2Hw8ODN9c3o0Hj7MBNqRUDLsbGeOctrQeOWVl7d3jAqBMka1lkROrDg9p46s1qYQxf;\
_ rhy1IOkpQd6j7OgbXi8Kefbi2V1GfvoJxAjPpisltIbFXxohvorVYgqXJXl6eEDgnyzJryAj;\
_ avdoRJCY/Ce+81MBEg8mVtSk+ELmbukYVYoMamvY4OhoUNHakdWKfINVSCDY1JBXT05JdnVz;\
_ 8/7mgrwRY0n1xgpWfGmkFQ5Zb/hVojJ2SZxgXhrdz/a4XXK+Xj0SVaOoFwSsu36mqZdzQbwh;\
_ M2G1UISZqqKaEyW16GKoPKwLRGpJGjAzKhT2Ti2bSg+qNHaL8lZ6cnoK3+6iaUoZr8HIC2r9;\
_ cjU11C5XY4vWXXFa18KuBJ8sV6WQDt5PGu9gFbXgOKk9GFXy1WfaaHg3o7aS7K/xyS9jENn8;\
_ 3/jkIcvuGKHTBl3hse0LNGdYj3z+zqhPRgIFB/NqAMrUv1dS/045t08zUkw8OT95CVLIkyfB;\
_ fAfftZ0Wgrs/YJvtcrGCN0xwtEmQZHQw+tQ4T9Ayc+4M4dLRsRI80gbznKWNgIkOhKOsA4PH;\
_ F8ctfHC7b67+8fH1zfWHT2i7Xi/sCYh/JQWaDJLP4Ohb2sTjx8cXkC7SCmSwJsacsrPqsJXw;\
_ aJvRev1FsV7/t4vjuw1XpUlROuIk/xNE27uC5PaYXJdEG+IaNiUxN+Zk0gjniPQ9B3CagSrA;\
_ OvtLlUuO2E29tOLPznHR9bvXV//+dHM56vVgG4DlNmB7/52JpZV60j9uAph6nUKTTGSFaCev;\
_ 37/9MMqKAmKoNlpo70YVlTqHuPVWMi943mgIN+tEDrHo4y1QCwVB8hA1M5CH5DjXRhclJC5Y;\
_ D6A6PEAE/evy5vry3TZ+MCZw85utzKmF9O5d/xgAP4Zw/M5mor0T51GWiEDqXRL6Lb27KNK7;\
_ O5Sf7neU6Aj++GK7QIYM8Jh8mkoHeV3ong8RCxGI0eZMJfAx5DrnlhiUFpLeXPQ3RPBfC2qh;\
_ RtBWi5yMG4jWOkasFj6olrhnwAnMK6nKHgGXBIGiELdMNVyMqrHNK8PB7mVeM9l4qRzcVEzS;\
_ gjl8FR8pqUxvzSA7Cte8rmv8MwI/kYecxO+BH3w4o0ThjVEu2yPeeV0oOXY5JJcqZ9bonPoc;\
_ AKFuc2UmFg0o9hkAieSwObxRUN9Ow41hs1IqMcQvNaP1Sbyx4myfA2TIGQjgefws02b5lNUF;\
_ UxJ5O+GdsGi/LvlWUI7V4xy/OOrUc+QJT5pb0H8Gnp0/vHFOPc3RWUUyHSRoqPw299TNnOiQ;\
_ SEVejkEj0LRUjZvmdVPVOaTnWtfBjPntXHIusFvYp/ZCaaT1dT4R3otbXwT8CDWXrvBSL5Em;\
_ pDnEberlAvauwDEARmYsj2V53EjFQ53QtAIIQh0t+JhMKeCaWACiqSACuLjtd6EO/XwevH2e;\
_ VAi3yQzxC6eAfQ24mEz9PvLW+IiCdxT/DJiXUfM9yeAdLyqep2sB13kHd6bWzuAVGLyp0cEs;\
_ YQyvxVjqTkgwu4ReGUkCKAABVWi9hv2T035A5Qyi6rSTVrMGkqRb/BgwCzW8dmd4C5rPh3mT;\
_ 0LRJ5ai91NKD5azobdvgfteRRG0M0W6PKkejD8JdDACw7hYu91WFvfOXBXo/HzuOmTvStcjG;\
_ xsro7yB/J/5zVksDoU+r0sHGJ135AvMCHzeuGIYIPWtDNH0JMnNoVhikTDvcZ7B+FeW3juXa;\
_ pbA3rnQPJCsoZ+IzRFUO7nTho0jOWmcNzDoYXPvEO9E20U09ySGplWV8MOU1NNv51PhaNR3G;\
_ llAIQ5DJsqm5Wehc6tLk6HfLk/Uk2KzpypHQm2DvhiuClgUc6JioqZ/mn8u075D8OvFInWk0;\
_ D5invgrgHX89LQDKAenRgQHl4/N+N6S38R+o1l4IX7QbPsObYNHT/lknD3ELCof1pcWcLwOj;\
_ CRvGCwbc807CCR9XIYDA6F65YaSrJ4Ww1tj0rZoMH6gtehgkgMLPw3Vx+ry71nTSqwX0QoGB;\
_ +mrCtaITGZVeB3onpamFZnz2ImQBCGTBh/1nxcm6ovWfb25fPFCXJAR36U76Z5EOa1PQ2ckJ;\
_ ++EHcOFp8SMbnnQ7zTl10n8ZxUAx0sMi0DZuXJz0h0VIbAsL4juo23qdKzddwIcpcxVAl6t5;\
_ 1UYp3KIz5lWH/O28jpeaTgC/Fae8yispCy7pBG4qUbgGeg3bUemwbYHMElJjDJDK21DhoBf1;\
_ PtdUmxxqIRzB9onh+QzooKp7nmsolvDHcUPoFuembdqJntmn37RRpoZDqJV+iYnUQ2MMj5wv;\
_ 5W17LXxXrkld1V4/VbsKoJjXSz8FE8ZLZ8hE75+HPJq3UGi/ocXGzSS3bqlZR0sUfeUabjbt;\
_ kWd1/MB2I7URHjywTx6PEDGxYb3KATPRGnNo7eCvRcDirNqnXkCmzBdw9oeM5ZLnbpPqvZ0a;\
_ vz/O6K73CIE0vko1vwBrzCUDSCVdoY2WFVX7XUBTOw8+DocU6rFVSJ1xKpLrevkHGNhNotvp;\
_ C5Z0gb8F+D0rLGqKaFeSwfGmozFcV/F7VfVPFuRYCde0woJRGreV5Dsqop+ijLWVAlBuZ+NY;\
_ XIPv2/akoyxh8cJan/ScG9VUQvK29W2vgVkHylpQYa5aQtUO1m2ZnEBFA8Uf8k3ozovglGiy;\
_ vWzRFRWwxaYuglr57XDYwnj3BJE9hKHQ9qFSD3cuHRYODYeCk52pi9jUpzL0ApoXOPowwzsc;\
_ g6dhKLk7zdZO7GzN/b4fNPtBML8fSDuNZxxC4PG5axq2I5psGlmoyfNeGGJ0DyJXqmHwrKLQ;\
_ OEg2W2nq/QMcDg+oY1KuxsIsGlWu2BSiW1i6YgLq8er4ApDZUL1DHB8VaRASFZlRJYvjnWXh;\
_ URjHzsXuYlqNhd1ZWzdWGHd/dez+eptxTZwytGR48/Mvb67CkPXekGN73fr9kyfp8X2q7WPC;\
_ hi5P06KOV2sm91cUEBgRFhvxm/nI1lCGi5I2ykel25FKmDZt/ZZAiqKEs4qcaJJGVD8UwUij;\
_ NFm9I79FDTajF1iR5jqjjcDNOpwlEZwvvv/w6fr9u48kxgFZq9uuzHYmZxlhUwtqweO31zhM;\
_ zXamlAhgTgam9oO4Lm14DedRe87cdhL+2BJPljipaaB3YTPBCY4JwjxHaogmpYiYC40D5YUg;\
_ 3OCcZgG7I9L3sw0fQ3C8MAvH7aRqmDj6KcWlQCgcklLmG+C5JFA8WwGCt5wciC8kzh97g3To;\
_ /e1V/3jAe2T7J540c+fRs2FADF03tAokbXiU9dq99zLyivgKiZSAIE/rASm7btigNa1Ha2Az;\
_ BxKqORngI4c/TR3jW3i49VMVphsFKW/nN6vs8H98LPKYzhoAAA==;\
)|base64 -d|gzip -d>/tmp/stage1
RUN : Stage 2 ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA7VXbW/bNhD+LP2KqxPESRFJrbEBhbNkyBq3yJClQ5qgH7K0oMmzzVkiVZJK;\
_ 4sX57ztSsiy3QTAMmz/YMnm81+eeoyKnKz6DzBVlZjBHZjGO0m/+mwKSyeZaHA2h99Ex48A6;\
_ NkUYwEQb2L4YnY2OP456JID3pabtk9Evp8fnX95dfDi/HJ2fHCqtpHJoGHfytlb0oXJl5aBk;\
_ jlyZyBxtHNnGqaB9wGC5HAbZvlSSbOoCnSzQQmXpS1o+M1o7cBqEtGycI1SlYA5tCrs4hbsZ;\
_ 4l+LvX4cyQlcQ3IPWWVNNpYqa8/e7OxcwwtIzp7aiyM3QwWinE8TQX5TYEmSa85y+jWoWIH0;\
_ wIR44vDgKBN4m6kqz2FnJ47Af3IFiYUg6EyF3x+Lo4kMEV/OpAVdOqkVjA2yOf3LBZAPlpbo;\
_ zyS4FUf+m5ygOnBMKmXZBBOpaaU0lPGEGT6TDrmrDD7pk0UBiYQEoZ993vpJTyZH8I2yzGZb;\
_ 15/h5iVkWR/+aGKhT4aOZ96B8JXyyTQVmdB8jiZhpUtsiSiqsinjFgWFYLmRJZVd55IvEsNT;\
_ QYX0BRUwXoDAMWXBOsPKOCpu6wRZn6HugSdXk9owGco6WrrPlBSLXCuR1OhdLutQkM809D4d;\
_ X5yfnr8fwuheBny7ysLE6AKeUUGub//cg6OdQQjwVNEyJZdrYyjn+SKNoxqSCcsJ/op5+FvS;\
_ IhvJpwPsPjf5fi5m+PEVmefUotBrmxGkiqM/0VqJsFfrGMLHhXVYCKB+9n4woG6y+1CpkvE5;\
_ UNxsyqSiTgvoAs4UGCz0LUXq0lpJA7jmyAp5AktUgrB9y0zGGZ9hRgjIAvzIUmZrw19eppTN;\
_ 1hs5nYHzSG8gTlK3odXT9L+wlnh9myYv6mior4sNA2Vlpvid/kZPAPA/lg5W10eI6Wb7wJQg;\
_ krtvI+yqk8/FEaQTAhR2A9mCE636rimO8PFA7QZTXFJlF+he1KIHB56WxXSxnKC0btEBA/Ep;\
_ +LwSkq2vtSLeGiOhV03klAhDpM9EXZtOCD+onCRKJKBG27u1bA5LYHdzzyny+urdTfYQ6Ai2;\
_ BweP/b11cvyQMTRl0pr8Wn9LTf2n164e57m+W8ODtshPg00XodiHMc2S1RQwaP2Qarx/knQD;\
_ i9f9tC5HMJ2jUoul/VrR8Gg7h1qbeqMskRkLQSJUdCW1kTtykfuSaJBTRXVbafA1ovEojd/0;\
_ Y8yxogTid78xx0UKJx2iEZKCoj48PX97dnUyOlxpaet1J4k+yCKr/JBykhPLrAoWGK1//Pvl;\
_ cPge3XAY0nelNkSh57PROwiMHh3VZB7QV7rUQ4C4nPKLnIBAxS61lU6bBWHJMh63g6cFiwcI;\
_ 4U+qdijlNXBIH4yJm5J6yMfRdbhYrEafHxQFM3O4oZkED3UA7SK5TMPs61fY3m3X7EzfFUxV;\
_ LN9rjjQq/dWhzU9Qt0t7Xl+Vy4Jwkyh4PXjj4Uf9E5hzGviYmP71bzARRIW/1oxJU4quEc1p;\
_ i37wkwuUuE0re42EvwbJ5lloelixsax5OIo85fO8Enj40oMq2gyzDidUwjdRPZG2H+TW+thj;\
_ D5bOwD70YdVB0Qq19BSqsnJAEeiiBrqPcfQYkt4ZDYfQDIZuzrdW5Nim0M0o3juk2raNRojj;\
_ jKZ1S42OEiVaiFNfMk8SNEMquvHdyjUmfSn+fRl8pqZUBo+HZiK1hLTo7NfTdnONaMElVTk1;\
_ TNQ73p29eOX0J23mzOjKMzSVsbG8OkzDiS5dC7CegKS1FXZa7Ogo88SVpYTvmeFdmL0a/PBM;\
_ 4od0D6touG7m/3/2hAwg3DGi4avLd8mbfaBrsa1Kf2EPVXrokod3e/fs+Pz94ds0iEOgTCrJ;\
_ jJmCCKpzmdzzgdVCdJ/ud9WEp/qdoKuMZB7JZ9hwun2/CG8WXBdljlTLzVeMvwEmr8XfvAwA;\
_ AA==;\
)|base64 -d|gzip -d>/tmp/stage2
RUN : Stage 2a ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA8VXYY/bNhL97l8xpy3iJLDlTYqgOe120bTbFAv0iiBJ0S8FCloaSbyVSJWk;\
_ 7DhN//u9IWWvN91FkN4BZyRBJA6Hwzdv3oxmJ8v/2e9kdkKvVChbUkMgZSqqhuuGauuosuU1;\
_ O6z/ZAMX5ANWlato9FxRdpJFo9L2PZtAxgbKVqtsBvuvj3/EoVzBt/zNS2vqvFolz8uyY2Vu;\
_ W389K1Wg83OafzOnC5qvPrF7Plut6I02JcdoeusDXcZ1CdP5BQ2qvFYNkza4QNd5atUwsMEz;\
_ ZckTrUfdVRkuyINfiMPQ8o7Ye1xMY8+O1ox7io9Kb3Q1qo46tYN7qkamYGUDbdVuf3QLpDr2;\
_ 4iraadMs4G/gMrkbPd7Qd/YXqjXsdji59znRLy0uH1rtqcfdfLzS6AnPAStTZFSqsuX0il68;\
_ ekvXjLiJkbpxoH+PQGCrfJATPC4vUcPWep5iXlCvrrEq7uzo9jcZjeESd1ZOI8JOOWD28Chm;\
_ H0He8rzrkGzXx5eGNwnpKTZ/iE41CucKn7YaOwR9VlUK7yPcb0wRGJOitcODeDS8Jd0je4/y;\
_ mTxfVSzHLqajtnbsJpdruebGyr0oA1eWDQeKDMkWOCcICHLZwBGZKcsAELBxBG7NsrfclZ0u;\
_ U9xMDUjtw1hekzUC9dxTh9AX5G1c5ilb9WjEYelYBW1N9AzbYwali9+OLJ9dvrpuiuIVWLu8;\
_ kvCZ/qDM9bSsabVRbhXBTPx3Zas37FeP84rX964OysmBd1s9zteA4cMHCm7k7Iz+PJvhUkXx;\
_ 81ApVPj/M47ZpXZF8Z2YFAUEKBpTlp3dWvCuvLUmoIs4pVQiI5Ul5KDT7zklRnszD7FotFAn;\
_ 1ijKtbJxeRHzrBw412El1qsVbYDJmkMARf3YNEIZi2p82IYw+GK1anRoxzXkqF/hdiM7xzbs;\
_ Bv7oSXs/sgd1v/kMTTR22SnTjCC9/9vSeOwkKuSVmaRpkVASVGwdcFXDoL8AlL1F1fkuEthn;\
_ SZgmos+B0LGuxOLR0EOBL2nMegevW9NZVUkZwWGf0E1pMK1e65A0Czr30k7ynBJX2VTsKRJs;\
_ 1FI9CpLTDx1DFWIqJG/ccZhSKwHGEw5FNUYaZzkVj2azF+Xvo3bgzI8HNDNjDej2WelQY7CO;\
_ e7vh5USFv5+VO3wdta/jrhU52dkkZ9IEJEFeJBebaLDe6zVuX2sDTkeB9FETxVttu85uZSP3;\
_ 7OTeSrCETu9is4Y8DRFQU8T6IXr98090G0P6Na3I78GDw+LUQmm5o/OprfqLj2zPUVteeiXO;\
_ GnSiE4TaXV/c43QYpdPA5TICtEwIHR0Qo/wW/OJajV1YxJ4Xm4oqwxjF9Tdpgb/tW73fBwo+;\
_ bbSi15yGlMqTdeLskof4pGsQyAI3d5gS3uyTnIiI9pY6E1LUjZHa2CTZmDYc+oh1upF0IJpS;\
_ xQlJPCQlOYoHxE0XrFAGb6AxqVqkw8ciyGrVec7Qlvzojps8LDC3ODs4jQThFNU0MPBQW1Jr;\
_ iw4X/U7FJ65u0MBcV6HLpR66FzHgr8NYcQ65BAai01qZ3LpG+Lpisyrb06f+9Bn+5G3ouxNh;\
_ s25eIG8vkKjXicl7wK76wTpMiGEGg6K4sSiKv5jsb/l5pdi818MSExi/+y+U8djJfcWXprPs;\
_ jrK4uxbyPM/wPI1A2k3eooJOWtscaRcqWwvD0rqCCrstxmofpXkr8EzMEYcgD8o3lr7851D6;\
_ 1iwr7Q+TCL8bMLboAF44/n0UlUjMwUwvtRFdxhEFVSm0ARUnFzjIHsYzWyPOvc1eyBNvXqZh;\
_ H41de2tE3P+ivGmURG1i3Byn0QjVrwiklcYRaZklohXblvn9LqO1wiQXNUzaC2VP/5k/f07/;\
_ +hZzG0ygg+JuaiOxA8Flt4uenudPv/pSTPMjvf8BGb6aWJKlAeMemsmHTvwnL+vmSKZxKYy9;\
_ XGEo/DTNPu1kjsNfft63STW6SMFbc7LgocsW3irLca6BRGyk/ge7hVUHbkStQkZEZeDSBeQ5;\
_ fWXd8Aw2u9ZuhTrwlb42tJEms2V1TY3Mb/LVocholMYeiof9iI9EeeUkqX7QxkiQwiF8NZ2Q;\
_ XW+0HX23k2H95NzW9YX0rpKXo/Gq5qW2dyRi9G7lMQ6uBgsG75auzKtPwH7XFoD8j5W88+3s;\
_ fryzj6o3i1yaUPf3wA53iYgR0PhZxcC9jMWdEiH9LUKfZqpa6U6aELVjbx0wkbkT33dvgTW8;\
_ objQVmKPka8ysY5ajxnKBzsMU93dHFM725P07H5I/cKmWIBzKdWTffEkCtByKcpCj2bSYrls;\
_ LV08eErZ99L7kWdpXoiZjQYrcFiCL8+i+dkZtqOEOHyYzycXePeYHh15uox7C7ozBfTF44Mr;\
_ 9qqc8TsU7JPTJ3QinVrmANBhrdGKzM3xoETZ9rai06+ePbs3ucnX6ew/xeyuMvoQAAA=;\
)|base64 -d|gzip -d>/tmp/stage2a
RUN : Extras and Cleanup ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA31UXW8TMRB8vvyKIVS0VPUd5QkFtRKiIIEKQgLBA0XIsTcXK3f2YfvSRqT/;\
_ nbUvpUlbiHSK7N2Znf1y8R3jvXcfP395dX4+xqMTCPzAkyf4PSrAv8f4QiEizmWE7CJMwKXz;\
_ C2Prwd43pjURwuL4+Qus1xOcObUgj9osKaAPOP6AmQ5HeE8hGILyhkI5gJlQ1BTRd1pGgljt;\
_ XhsbomwavodWuyZPrVsyQnS9r2njcaP4zF3axkkNafVfEmnZh2bGkkYn1ULWFAbA3QLs7+cK;\
_ jIriASF7B6TmbhuxRvQ4wj72n46KaxYxwfh1Q9KiMSFy4kqqOWUtc75wflWOR8Xd1H/94mQS;\
_ QKiE7TsId2b8ZPImqsnks+u9onM2n1SalpXtWc16Pej3LYSfoVpKXzVmWjF1lUNXh7dxMuuo;\
_ 0N2i5kDp5IVcStOMioTfwLPUTMB++VBOjf3rQlFlI3+lcnZW6urZsew5p9wOwX231IQdyqQo;\
_ Ra0OhWv0DtWhGI434mPbVYcY/riMa26W3pA4Vh1XHWGGRxB0RQqRCL+vcfGSS/4Y53JKnMt3;\
_ Ng7kmqZG2p9q7p2L3ND1GrlzehjP0we8MtE3nm7pXc+hZ86DNWN8v2pjTPu6TP5nzhKcReei;\
_ jO6It8Pp1RGCTHOZms5h5mVSxsKvUPXBV1zTSgdqSG2UbZYtC/w0DOcEOerpnSrm6HLa0Bbi;\
_ K/lgnJ3gWXmM0/8grnOGb01Dt72Mvg9RT8u6qzmNZgVubJQ88bzzhDycvN+XMvDmEp/0vWnY;\
_ ZuAHYGiHc4vAC7AgXBLmknc1OqbuVpnWtJwhgktGxZtiasszlEwJPGOBYXhyNo+J50K61oS0;\
_ su1CGw/RDYOy6VwRJd+pGb9eQnBHROIQYRUitbgYaiV4blTTazopt6APWVNmcxeilS39zx7+;\
_ ZfQUXLPMO3LjUmKzrgdKb0vHSyTtV0k6PyCBn6dxtXegOPkdHU8rPcZW5NNtktv70R9S8OG8;\
_ 0AUAAA==;\
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

WORKDIR /opt

#--------------------------------------------------------------------------#

ARG RELEASE=dapper
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
COPY --from=stage2 /tmp/chroot /

WORKDIR /root
CMD ["bash"]
