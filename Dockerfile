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
_ H4sIAAAAAAACA81Z62/bOBL/nPwVrJqrt6lkx0m3jyxcINcGuADbB9Lu4oDduwVNUjZrilRJ;\
_ yo5b53+/GZLyI1a2+2lxRWPJEufBmd88OD44J9lHTyeCDElpLDm6vvz58uLjJTm6uH79r4wc;\
_ ffx08fbD4eHBm6vr0aBxduCm1IoBF2NjvPOW1gPHrKy9Ozxg1AmStSwyIvXhQW089Wa1MIYv;\
_ V45akPSYIO9RdvQNr+eFPHvx7DYjP/0EYoRn05USWsPiL40QX8VqMYXLkjw+PCDwT5bkN5AR;\
_ tXswIkhM/hPf+akAiQcTK2pSfCFzt3SMKkUGtTVscHQ0qGjtyGpFvsEqJBBsasirR6cku7y+;\
_ fn99Tt6IsaR6YwUrvjTSCoesN/wqURm7JE4wL43uZ3vcLjhfrx6JqlHUCwLWXT/T1Mu5IN6Q;\
_ mbBaKMJMVVHNiZJadDFUHtYFIrUkDZgZFQp7p5ZNpQdVGrtFeSM9OT2Fb7fRNKWM12DkBbV+;\
_ uZoaapersUXrrjita2FXgk+Wq1JIB+8njXewilpwnNQejCr56jNtNLybUVtJ9vf45JcxiGz+;\
_ b3xyn2V3jNBpg67w2PYFmjOsRz4/MOqTkUDBwbwagDL1H5XUf1DO7eOMFBNPnp68BCnk0aNg;\
_ voPv2k4Lwd2fsM12uVjBGyY42iRIMjoYfWqcJ2iZOXeGcOnoWAkeaYN5ztJGwEQHwlHWgcHj;\
_ 8+MWPrjdN5f//Pj6+urDJ7Rdrxf2BMS/kQJNBslncPQtbeLhw+NzSBdpBTJYE2NO2Vl12Ep4;\
_ sM1ovf68WK//x/nx7Yar0qQoHXGS/wWi7V1BcntIrkqiDXENm5KYG3MyaYRzRPqeAzjNQBVg;\
_ nf2tyiVH7KZeWvFnT3HR1bvXl//+dH0x6vVgG4DlNmB7/52JpZV60j9uAph6nUKTTGSFaCev;\
_ 37/9MMqKAmKoNlpo70YVlTqHuPVWMi943mgIN+tEDrHo4y1QCwVBch81M5CH5DjXRhclJC5Y;\
_ D6A6PEAE/XpxfXXxbhs/GBO4+c1W5tRCeveufwyAH0M4fmcz0d6J8yhLRCD1Ngn9lt6dF+nd;\
_ LcpP9ztKdAR/fLFdIEMGeEg+TaWDvC50z4eIhQjEaHOmEvgYcp1zSwxKC0lvLvobIvivBbVQ;\
_ I2irRU7GDURrHSNWCx9US9wz4ATmlVRlD4BLgkBRiBumGi5G1djmleFg9zKvmWy8VA5uKiZp;\
_ wRy+io+UVKa3ZpAdhWte1zX+GYGfyENO4vfADz6cUaLwxiiX7RHvvC6UHLsckkuVM2t0Tn0O;\
_ gFA3uTITiwYU+wyARHLYHN4oqG+n4cawWSmVGOKXmtH6JN5YcbbPATLkDATwPH6WabN8yuqC;\
_ KYm8nfBOWLRfl3wrKMfq8RS/OOrUc+QJT5ob0H8Gnp3fv3FOPc3RWUUyHSRoqPw299TNnOiQ;\
_ SEVejkEj0LRUjZvmdVPVOaTnWtfBjPnNXHIusFvYp/ZCaaT1dT4R3osbXwT8CDWXrvBSL5Em;\
_ pDnE7WeAjhQBsXuwgU16UfE8XQu4zvfhQZla74lXoHdTo51YchVei7HUnZZldgktJ5IE24Ih;\
_ q9DBDPsnp/3g3BmA87STVrMGco1b/BhcD6Wwdmd4C5rPh3mTnLLJiKi91NKDH6zobdvgbvFO;\
_ ojaGaLdHlaPRmuEu4ghAvOXefVVh7/xlgcU2HzuOCTDStQDB/sTo7wBoJ4xyVksDEUSr0sHG;\
_ J11hh+HFx40rhgHoZy3S05cgM4eazyDz2OE+g/WrKL91LNcuRY9xpbsn5qEqiM8Azhzc6cJH;\
_ kZy1Dj4MXsToPvEOaCe6qSc55IayjA+mvIaeNZ8aX6umw9gS6ommlYCbpuZmoXOpS5Oj3y1P;\
_ 1pNgs6Yr1UCJxxYIVwQtCzgXMVFTP80/l2nfIYd04pE602geME99FcA7/npaAJQD0qMDA8rH;\
_ T/vdkN7Gf6BaeyF80W74DG+CRU/7Z508xA0oHNaXFlOnDIwmbBgvGHDPOwknfFyFAAKje+WG;\
_ ka6eFMJaY9O3ajK8J0XrYZAACj8P18Xp8+6U3UmvFtBSBAbqqwnXik5kVHod6J2Uphaa8dmL;\
_ kAUgkAUf9p8VJ+vC0H++uX1xT3qXENylO+mfRTpM8UFnJyfsyRNw4WnxIxuedDvNOXXSfxnF;\
_ QE7XwyLQNm5cnPSHRUhsCzhgn3RQt2UvV266gA9T5iqALlfzqo1SuEVnzKsO+bF8wvmm4GO8;\
_ 1HQC+K045VVeSVlwSSdwU4nCNVCybUfBwOoPmSWkxhgglbehUEBL532uqTY5lBQ4yewTw/MZ;\
_ 0EFx9DzXUHPgj+OG0C3OTdu0Ez2zT7/pRkwNZzkr/RITqYf+Eh45X8qb9lr4rlyTmpO9tqR2;\
_ FUAxr5d+CiaMl86Qid5/GvJo3kKh/YYWGzeT3LqlZh2dRfSVa7jZdBme1fEDq3aqxh48sE8e;\
_ O/GY2LBe5YCZaI05dEjw1yJgcVbtUy8gU+YLOEJDxnLJczdJ9d5Ojd+fCnTXe4RAmgKlml+A;\
_ NeaSAaSSrtCNyoqq/S6gqZ0HH4den3psFVKDmYrkul7+CQZ2k+h2+oIlXeBvAX7HCouaItqV;\
_ ZHBK6Oiv1lX8TlX9iwU5VsI1rbBglMZtJfmOiuinKGNtpQCUm9k4Ftfg+7Y96ShLWLyw1ic9;\
_ 50Y1lZC87SDba2DWgbIWVJirllC1g3VbJidQ0UDx+3wTmtwiOCWabC9bdEUFbLGpi6BWfjMc;\
_ tjDebcSz+zAU2j5U6v7OpcPCoeFQcEAydRF741SGXkDzAicIZniHY/BQCSV3p9naiZ2t8dn3;\
_ g2Y/COZ3A2mn8YxneTyFdg2VdkSTTSMLNXneC7OA7nneSjUMnlUUGgfJZitNvb+Hw+EBdUzK;\
_ 1ViYRaPKFZtCdAtLV0xAPV4dnwMyG6p3iOOjIs0ToiIzqmRxvLMsPApTzbnYXUyrsbA7a+vG;\
_ CuPuro7dX28z9YiH9ZYMb37+5c1lmFXemRVsr1u/f/QoPb5LtX1M2NDlaejS8WrN5O6KAgIj;\
_ wmIjfjNm2JptcFHSRvmodDuZCEObrZE8KYoSzipyokma9DwpgpFGaUB5S36PGmwmGLAijUdG;\
_ G4GbdTiSITime//h09X7dx9JjAOyVrddme0MoDLCphbUgsdvr3Amme0M+xDAnAxM7QdxXdrw;\
_ Gs6j9py57ST8zSKeLHHg0UDvwuAsTfC0HcYiUkM0KUXEXGicyy4E4QbHHQvYHZG+n234GIKn;\
_ 9FmYayZVw+DOTykuBULhkJQy3wDPJYHi2QoQvOXkQHwhcYzXG6RD7++v+scD3iPbv5Sk0TWP;\
_ ng1zVui6oVUgacOjrNfuvZeRV8RXSKQEBHlaD0jZdcMGrWk9WgObOZBQzckAHzn8hecY38LD;\
_ rV98MN0oSHk7P/1kh/8DL/dpUxUaAAA=;\
)|base64 -d|gzip -d>/tmp/stage1
RUN : Stage 2 ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA7VXXW/bNhR9ln/FrRPESRFJbbABhbNkyBq3yJClQ5qgD1la0BRtc5ZIlaSS;\
_ eHH++w4pWZHbIBiGzQ+2TF7ez3PPpSKnKz6j1BVlakQumBW9KPnmvykonqyv9aIh9T86ZhxZ;\
_ x6aC9miiDW2ej05HRx9HfQiIu1Jj+3j0y8nR2Zd35x/OLkZnxwdKK6mcMIw7eVMr+lC5snJU;\
_ MgdXJjIXNulFtvEqqN9jQXAglYRBXQgnC2GpsviSls+M1o6cpkxaNs4FVWXGHNTQtpjS7UyI;\
_ vxY7g14kJ3RF8R2llTXpWKq0PXu9tXVFLyg+fWqvF7mZUJSV82mcwWlEFce55izHrxGKFQIP;\
_ LMueOLx3mGbiJlVVntPWVi8i/8kVxZaCoDOV+P5YL5rIEPHFTFrSpZNa0dgINse/PCP4YLGE;\
_ P5PgVi/y33ACReAirpRlExFLjZXSIN0xM3wmneCuMuJJn6zIKJYUCxqknzd+0pPJIX2jLLXp;\
_ xtVnun5JaTqgP5pY8EmF46l3IHwlfDJNsjTTfC5MzEoX21KIrCppuRwiqA0EJchyI0vUXOeS;\
_ L2LDkwyF9AXNaLygTIyRBesMK3tRcVMnyPoMdQ88uRrXhmEo7WjpPiMpVnCtsriG7nJZhyL4;\
_ TFP/09H52cnZ+yGN7mQAt6ssTYwu6BkVcH3z5z4dbu2FAE8UlpFcro1BzvMF8FxDMmY5sK+Y;\
_ x76FFtlIPh1g97nJ93Mx04+vYJ6jP6nfdiJJ1Yv+FNZKQTu1jiF9XFgniozQzN4PRugmu0uV;\
_ KhmfE+JmUyYVOi2gizhTZEShbxCpS2olDeCaIyvkZaIUKgO2b5hJOeMzkQIBaYAfLKW2Nvzl;\
_ ZYJstt7I6YycR3oDcUjdhFZPkv/CWuz1rZs8r6NBXxdrBsrKTMV3+hs9AcD/WDpYfTwCmpvt;\
_ ElMZGO6ujbCrTj4XR5COASjRDWSDjrUauKY4mY+HajeY4hKVXQj3ohbd3/ecnE0Xy4mQ1i06;\
_ YACfks8rkGx9rRV4ayyAXjWRUxBGljwTdW06Bn6EchKUCKBGm9u1bE5LYrdzzyny6vLddXof;\
_ 6Ig29/YfBjuPyfETxmDEJDX5tf6WGv2nH109ynN9+wgPbMFPI5ouEtkujTFIVlPACOsnVOP9;\
_ k6QbWLzup8dyBNO5UGqxtF8rDI+2c9Da6I2yFMxYChKhoiuptdzBRe5LoklOFeq20uBrhNko;\
_ jd/0Y8yxoiTwu9+Yi0VCxx2iySSCQh+enL09vTweHay0tPW6laAPWGSVH1JOcrDMqmCB0QZH;\
_ v18Mh++FGw5D+i7Vmij1fTb6+4HRo8OazAP6Spd4CIDLkV/BAQQUu9RWOm0WwJJlvNcOnhYs;\
_ HiDAn1TtUMpr4EAfjcFNcZjwOHkVbhWr0ecHRcHMnK4xk+i+DqBdhMsYZl+/0uZ2u2Zn+rZg;\
_ qmL5TnOkUemvDW1+grpt7Hl9VS4L4CZW9HrvjYcf+icw5zTwMZj+9W80yUCFv9aMiSkVbiPN;\
_ jPSDHy4gcetWdhoJfweSzXOm8bBiY1nzcBR5yud5lYmDlx5U0XqYdTihEr6J6om0eS83Ho89;\
_ 9GnpDO3SgFYdFK1Qi6dQlZUDCqCLGug+9KKHkPTOaDigZjB0c76xIsc2hW6GeG8Fats2GhDH;\
_ GaZ1S40OicpaiKMvmScJzJAK170b+YhJX4p/XwafqSnK4PHQTKSWkBad/Xrarq+BFlxclVPD;\
_ snrHu7PTWzn9SZs5M7ryDI0yNpZXhzGccOlakPUEJK2tRKfFDg9TT1xpAnzPDO/C7NXeD88k;\
_ foh7WIXhup7//9kTGBB0y0DDlxfv4je7hGuxrUp/Ww9Vuu+Sh3d7+/To7P3B2ySIU6BMlGTG;\
_ TAGC6lwmd3xgtRDu04OumvBUvxB0lUHmAT7TmtPty0V4reC6KHOBWq6/X/wNqAgzobkMAAA=;\
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
_ 9qqc8TsU7JPTJ3QinVrmANBhrdGKzM3xoETZ9rai06+ePaP53blNrk5n/wEV/Mlv+RAAAA==;\
)|base64 -d|gzip -d>/tmp/stage2a
RUN : Extras and Cleanup ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA31T32vbMBB+tv+Kr25pthBb7atHA2PZwyCMQcv20I2hSBfbxJFcWU4b6vzv;\
_ O9tJ12RlBmN0d9+Pu5ODe0QXX77e3n2czyOc3SDGL1xe4jkMwM857qj28Ln0kJVHUePRulVh;\
_ siHPsTgjj6bS0hPi7XG4MLWXZclxaHWccrS2G0bEVeMy2lccRGf20ZRWakijX0ik4RpaFoY0;\
_ KqlWMqN6AJz2MBr1TYRB8IaRi3ekcvsa0cI7TDDC6H0Y7NhEiuhTSdKgLGpfT6Ckyqn3knPA;\
_ um0ShcFp6w8P3EwHiFWHbSrEdla4NP3sVZre2sYpmnP6RmjaCNOwm7Yd/Ls1YreE2EgnymIh;\
_ mFr00mL8V6dnDQNdrTIW6k4ulhtZlGHQ4RlOXvVQfhNlzTLR4upaNmy4n3W8ImeorF/qD3Id;\
_ pRjHttRHVON4OB6c+XUlxhg+PKOWN6H3JJYt+W1FWOIMMT2RgifC8w4/P/A8zzGXC2Kj95wc;\
_ yDUtCml+q9xZ63lbbYt+LdoqtonpG1U90Q++fdLZhqWX1oE9I/p3JBEWTZZ09TNrCNagsl56;\
_ O+Hba/V2glp2l67bKMvkSeeMjT9BNLUTi8IIXVNJau9s/zP0Br8NNy9Frzo9mWKvLhclvUJ8;\
_ J1cX1qS4Sq4x/Q9iF/4BkBTlh44DAAA=;\
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

ARG RELEASE=unstable
ARG ARCH
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
