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
_ H4sIAAAAAAACA61VXW/TMBR9Tn7FVUEEhhpraLy0GxpiTEwImLrxRNnkJreptSQOttOuY/vv;\
_ 2LEdkhGhDdGXxvb1Peee++Hg6GR2QGopiFxRgSTFBedKKkErIhPBKiXDMJhANMOKMgFHuGC0;\
_ BHcUhYHEFMYI0R6FFJe0ztVlwYTgAlZKVRNCqEhWbI1x2tyMuciI/YxgHgagf/sweqppkM0K;\
_ 8WY7gje9dfxqFAbF+v5e/47l+JmrscA1v9KcHNEr3MJSk6m4oop7vqyhLA8v5s+1gWBlNn8B;\
_ 8c7hfBeI0PETaz7Wh3FWZYeRQ7PbFs0J8nVRl6r2goSBATt7Nzs5PQdWwoYKtYUVp2Jrv+NF;\
_ zfI0tVtuEQYphw6vPWYoJ3hZpK898lPrc2RsSwyDvITxUkJWK7l1JplmvtZS9EL08s/juiFK;\
_ eJ5qjXKkEqXf8yAprSoUNrxjdu1jcy7ASSXvIXRFJE+MhN5fw65PiPSLJN7p8mlJUo8FndL0;\
_ 8MQajR0tfbvga0xNsqTJ1mPQ76vzKGC3/1jMigsl/zeiSdlbXVclbrAtSq9rGNDNVdtm9kbb;\
_ Zc3SNJTuxuj44GD3Z6Ux1LTEazW90x1KblCq7QsCP227Nscw0tW8rPPbhMuCJbcpkwm/tZaj;\
_ nt3wVBgowzjhhQu47+HfBOr7mE7d+vhgdwomLBfmXdSZLq0Wf2jrFDU1FgYZU5Dkug/9BBsv;\
_ wKUzxTXmftvEKnWw2j7OaV0mq4qmcYnK0SYvJa91o/soHPswSCoYU+jv/o55x4Q3qEbcnUxa;\
_ 7EQgVQhqhXoeruvfgzu2JboPTZySpboc7AiwZj4u0+CTC5+AeGfyt1zYu0O5mERdj3q+DReF;\
_ fhdi66R5JgoUGaZR2E47R64hSmXC2ODJAvmmzpeDZ5pZQVHQ4UMUaF87J9b9bHfz2eFpP334;\
_ bdhM+UT2Tx6eyNNa4JczlzOvGTAJH87PT8/C4JuR05YqLRZ6csN3ePbMCp0J1Ng/GsEvBuSW;\
_ Uf+mudcdW7sM6lKigqP3x5cN3uWnk9nsy6x/r+H5keYMVlSC1qzxDRaox/BKG3UJPgxLl03Q;\
_ vtX9MNon26fF/McGpsmK+Ti0DjoEwl80Jv988QgAAA==;\
)|base64 -d|gzip -d>/tmp/install;sh -ex /tmp/install;rm -f /tmp/install

RUN : Stage 1 ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA81XbW/bNhD+bP+Kq+LVi2dZW1sUmzcXyBIDM9C8wE6HAc0W0OLZZiORKkk5;\
_ 9aL89x0p2ZYTp92+FAsQyCLvjQ/vnjs1+hBMLJsj/AAzpaE1Hr4dHk2G0DoaH/8WQGtyeXR6;\
_ 0Ww2TkbjQZQbHZkF0xhxnCpljdUsi0ysRWZNsxEzgxCsTQQgZLORKcusKm6V4qvCME2eDsHZ;\
_ HgStO/fsh+Llj6/vA/j5Z3KDNl4UCUpJwh9zxL+xuF3QYwWHzQbQn5jBe/JRRvdsAE4Z/iz3;\
_ 7ALJY2OuMYPwIyzNysQsSSDKtIqjVitKWWagKOCOpJwCxgsFb56/gGA4Hp+P+3CCU8HkFgWN;\
_ H3Oh0TjTW3sppkqvwGBshZK94JG1I8430gNM84RZBEJ3syaZFUsEq+AGtcQEYpWmTHJIhMR9;\
_ BhNLcl4pWUFOMLuA/NmZjhfCUii5rml+EhZevKC3+xKamSifHuRbpu2qWCimV8VUO3QLzrIM;\
_ dYF8vipmKAztz3NrSIppujghLYEqePGB5ZL2bphORfx17uTdlFzm/5s7eQrZHRD2YrCvPOp3;\
_ 4eD08s7OtzGzFUgUYLRMIwomu06FvGac68MAwrmFV9//RF7g+XMPX+OL2ElEbj5jNti1opHn;\
_ MXKHifekpAd9oYwFh8ySGwVcGDZNkJe6Hp6X1UEIogYaFu/JQU8FvWkuEs5Ldqhe1km1jyPK;\
_ nZPhr5Pj8ejicrAFs9yp3pxa9fObXmettk39tVuP+gO3/9V431hed9Dpd9am3DVuzLmcaLf9;\
_ XREo7yF0qUCkGm2sHRx0+kSDlcTDWHalmmsPz+qGNvL9cBtjv3O/tZpICGcGjOD/Qql+KiLt;\
_ AxjNQCowebyAkvO7MM/RGBC2bahMbigUMh181eCqBNtNF5by1688TFSWa+5p/3WDKy3kvNfJ;\
_ fV209/qp3DgXrnDh+Pz0YhCEIdFBpiRKawYpE7JLFGS1iC3ybi6JObTBLtGKLX+SNiZU709p;\
_ x4ooVUy7UslwRhxM8lQfzcY22CXT1Ius6XWoOqfEHV8I14PoQPn9aDw6Ort0Xisbg8qCA+QA;\
_ TnMqX/wUJznHSEj/dCU+R1fVkEvOUpoIOBBDWEz39/UPdO/C9fLhH5fjo0E7DCuLg1KLd6tn;\
_ SM8lhGHlyG0vhRSWENF0JHeDDzjQneGRVfpfdstrCz0Ytewsm9fnVZ3LalDprkNwl2BUgqFV;\
_ KjGbN8f7Sj7lrNYWn/RYd5ZnxtL5fAIw69GooAkN6qWI0bTrZoKWf0LQ3mI2z+bLegz723GR;\
_ 5DGtpYwSUMQ3BTU0+zjGp2wyEwtRTFHd5smsoJkiZahZEaNrtYeP9QnUnMmwKqnyIm9YIsLO;\
_ Pmm/40eVJe7q+PKlO9wOlJQsNIqimBMfeJ2B76rQqhIbWq6owHHr+cXl6PxsAlflQSroWnej;\
_ s+O3706G/e+CbQitajG4X4sHO5wSQLzQFAMtn45c+wx2+JtijDlEKrNRKUcLNDCqmKYFWDAD;\
_ LNHIuBtBbJ6VPZbaHJVRKBwPtk109Yvfu/bttw+1lzbsDNQ5DXRhmUDk5X299gZQTtSbru8O;\
_ cgDHudZELnUzPqhpPi9FdgLxHf6qdfduMrx2WJ6fDc8uJ/flevB4I3gQ4CyXfsyimf/+cYAV;\
_ NdQDdF8ZJR2AMMQwGSPYOJSA0WGEpCKhKQ6XRLhE2bcIXMm2hVtiL2ovvWBrRwHNrOzGTyLV;\
_ jfmWZBfMiZIiGqfKaCQmmyvPa5UD5GtLNTyiiqmu3vQ6Ed89aTVs8vKgHh/8lCltt+NAe332;\
_ dgBvwKZOKUFiDVJIlxC5FeM+sTpu02fN+ovLcUKCNIfWP72a/wBkWRBilA0AAA==;\
)|base64 -d|gzip -d>/tmp/stage1
RUN : Stage 2 ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA61XbW8bNxL+LP2KqW3kpQ21kZter07rQw5xDy1a95D2kA9pWlAkd5cnLsny;\
_ RS+o+987Q65kyXGCHnACtEsuOeS8PPNwOEkuix6aNPgmKKN4VNPJ7E7/An5MPCSIiXcKzqF1;\
_ Ac5eXX139eLHq+kkDMDaY4npRG28Q4mXV//85sX1r1+/+uH6p6vrl19ZZ7VNKnCR9IrmXYC2;\
_ Gld2g0p6UBFyxIeOog/OJUgOpI58YRRkL3lScTad6BbeANtAExfaNkWe8fIhx9CUbzv5t9NJ;\
_ 6pUF6Zcdk7gl6sSYcYIbfAdl+aCwwaV8V3g6AfoZCyxCGUkhq/vmtbpY8lOvIziftLOwCIov;\
_ Y7ELLUTHGRNBdReQF9mm3AwcddFiOZ2QaqgC+lQolm3krWLa4Rcf0FWMB9HrpETKAV1/2Ui1;\
_ amw2Bh48qApGJYFpYAoeNr+cfuna9hLuLNbE5vTNL/D2Y2iah/DzaBj+GpVEQwqUx0y03Uw2;\
_ 0omlCoz7xKJXSmYPNzcXaOEpWqggiqB9Au+MFlsWxEzCmkeQKurOoi4EDqkW6JiYAvfTybCq;\
_ PivROhS792vZHDdrDtY4bKNjohLOSlbReHNTzVGid3Dy+sWr62+u/3UBVxtd8JpyhDa4AT6w;\
_ BEbt7B8ncPngfPp+bYte9w+hlEDUw8kuJ04w5NPJf1WMWsHjqh/m0DYmNUjAFFkhxjkg3OMT;\
_ yNZzsQRUl3dcW4RMQSsIbiGowa1QwTSri4xYGUV2oJHKKysRoyseGsFFrxoMXlOQgzs1sW78;\
_ 68czdMJeG931kAixO6hu46rk0mz2/9iN0XrHW76q1mBCDkcb+Bw69c764zoFe395dtn1VuQC;\
_ fuifALeISr3ZW3i4nP6QHWU2Ey6o0ZA7lpBfEEARTeIYPkxQi5yDUVU2aWQY2hjXpSwnuUfT;\
_ ySQbPRBfWZg/PX9GmsLLCq2OdkX6g/n30EoEBmoDmGuF8iaUjQMPS+AZOZH99hucPdp/i71b;\
_ D9xmbh6PUzuVyswRQHuvbQ/GK6Eef0OyTSz7LnBZR0jvEcHPn6P9azwHtvAYTuF1aeloHybC;\
_ sraLcla8E6mfaXkTOctJIweWJk0Fo/HlspXnZY5ZDfOngM9zeqDXhwF5tHfJm9yVGYOTdQ0v;\
_ dG3QF4MMR2FKzpn4vv2RlFNGkzBMtDeublvdASay/IL1LuLnKAdMv7ouyeCU6IzaKbLros/4;\
_ vlP2xCDhOHpOoKvDvAjve3W+tLEurFZDfTArcqCjrk0e0PNJbVJ1C4l3AWm8drUPLid6lxXw;\
_ PPDadvsu8plQnqcelsZ1snry1rHUTMOc3qPO1LzVlTo2zv+2kyuqnc8+pYFOlPFOLoba90NX;\
_ vmhp57URxec7STxTl602qgyYdVCxtEYz159Rxwvun84+v23+fSeNFCSNtuoZjeFBIj75hM1n;\
_ 5+wzgWlC33JcsKezOcMJDr2TCLlFNvZrMNG1YIorAINoNvi0TC7o5UuCDpLLAUE6KBazL6VJ;\
_ QVQKLGm7hSGnBJZbBxaPRESJxbDgv2SIQ4qJsWfCaEzsIugR/HjWeeez4UGnLSEKqxM6F2Mi;\
_ shnfLBFeva9S3o/Aw5ajI6gFv009wqe+yPNB6ajCMwx7V4EYFOm7wCQIcWsFxGpozNIRpdW4;\
_ J+FlHjwkZdCCIocuq6Bb6YH+OySvPx1g08aywUFmS+69CjdKdtubFnWgNN8fFlTG7NkOTybi;\
_ uYWCag1WJnL2AY6uJMRueZG0O3tU5xq4Ab5eUvGi3/zn67fN76XugbPz5388PGQeT0F3O51O;\
_ 4d+1f4eAngAaXaiTyBddUZIIqZlmnexVOPmoLrNFc+h/87+q78UgNGeicFAJ5C07HUb5mCrG;\
_ A4RKJNoJT/vCTlJi1RuAqyNyej/jMEqSIqrMSscK4XYRMfCtbE2OPb6rMvfSC1bU3vpKXneS;\
_ zzgo1THlDF8qrDZhWITR5JF1PQENN0OdyR17DGIDl8kbSDwuo6qOGgG5WWkpFdWxow8QvMfu;\
_ PjnD3slu0KpdnF8Y49a31QmGHIGHSVKLaiVrxHe3BOQduqqMcLy3di/23d4d9hCbqMjFdF+Q;\
_ 77FNGmKNgay7GzNVc0JZCRjxHsX2TbkI7e4H++P5LdbqeGM5KA8/+grG6rCM/V51+KtnfK1v;\
_ /igV+WsXljwQ2RdUfVtX3R3nWN0hzW8hkgt1jFmRkgeKHOlxUEhfXjZ0tWlmaF8fBByXLdPx;\
_ Slgug8gq3mBkj2+FfwKsFkp6WA4AAA==;\
)|base64 -d|gzip -d>/tmp/stage2
RUN : Extras and Cleanup ;set -eu; _() { echo "$@";};(\
_ H4sIAAAAAAACA21RwU7jMBA9J1/xCCuQEK6Xa1ZUQsABqeICEofdFZrYkzaqawfHKUSUf99J;\
_ C+wCa8myPfPemzfjbB8X4dG7QBbkLRrfJXJO7gMs141ni5bMkubc5dlPFN+urm9uz2azAnun;\
_ ODzEbxwc4DnPIIvapOac0LeWEkMNH8Nv2mrAm0qeveR5VqI4d0werulSdwxDZsFbOwsJhDhM;\
_ ijz7LP7wAKVGgjIjt2+hwkUTy/IymbK8CX00PJP0qba81r537q/GlpFntl3ORWR8RUVragQS;\
_ V1A1NCejBT3uiQm+nlj9/YR6McOrsGa15OjZde/4NUXtmkqPkvpIBWd3qfiaS6tWH2F3SMMb;\
_ max9ZQXxkIaWUWMPip/YIDHj+QW/fshw9jGjit04fMU7Y5arhvy9WcQQkvzAZgM2iwAbjPjC;\
_ 9D+ordBdiEuKoZfSdYgQkyi+zqBA1c8nYz2x8wTdd1FXjde2Y8fm33rT6afGt3yqHOd/AONr;\
_ kBdYAgAA;\
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

ARG RELEASE=stable
ARG ARCH
ARG MIRROR
ARG DEBSCRIPT
ARG DEBOPTIONS
ARG INCLUDE

RUN sh -ex /tmp/stage1 && rm -f /tmp/stage1

#--------------------------------------------------------------------------#
# Patch apt and dpkg for docker
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
