# Todo?:
#   Lets Encrypt certificates. (Also private CA certificates ?)
#   ? ssh daemon to use screen from?
#   Name validation (authentication server)

# TODO:
#   Add linux cc.debian.buster.out

ARG FROM=debian:buster

################################################################################
# This is the basic build machine.
FROM $FROM AS deb_build
RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    apt-get install -y --no-install-recommends \
	wget curl ca-certificates \
	binutils git unzip zip build-essential \
	imagemagick pngcrush p7zip-full \
	gcc-mingw-w64-x86-64 gcc-mingw-w64-i686

################################################################################
# I copy the context into a VM so that I can create directories and stop
# it failing when they don't exist in the context.
FROM deb_build AS context
WORKDIR /opt/mcgalaxy
# Do this first, it can be overwritten if it exists in the context.
RUN [ -f default.zip ] || \
    wget --progress=dot:mega -O default.zip \
        https://static.classicube.net/default.zip

# Recompress the png files ... hard.
RUN set -eu;_() { echo "$@";};(\
_ H4sIAAAAAAACA5VSy26DMBA8w1esUJRIkQC1l6jfklYRGEO2YJv6QROUj69ZJy1pkkMueJlZ;\
_ z84sAACItkINuRV9XvG6cJ2NPQqsusWcHLGH9PMLctXbXLCm6IrD8dKTeZb6aqUBASWss142;\
_ BFUqjpiSA9cWkgUm4LV3L0RH/sG0M3tIS+0s/6Ooeg1NW0jNjPmA5RLEMEMm1TjSAtL6rkJw;\
_ IXlMVUgtVPlruJ4Mmxal5BVzJafr73FEy9gja7kkiGnOe66p7rEJp5JHKszek/ObBOxqF/pN;\
_ yztuVRAyPVZnnVGJEvnMJsB2ypEs6sRHPZ3A786idDyOfGiCvfc8u5uqcXidygM0xp871hXG;\
_ IKP3y3ebavQTTFiZcmz/nBcv/MALl8O1l77QFlnHwyxd4HkZUn2H9XbKVea58X7IzfjNCKml;\
_ 31Uc3qC4ZE03Y0aohtU6W6+C1eE//fj//gEnavZCMwMAAA==;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install

# Make sure the directories we need exist here, overwrite them by the ones
# in the context if they exist.
RUN mkdir -p MCGalaxy ClassiCube
COPY . .

################################################################################
FROM deb_build AS mcgalaxysrc

# GITREPO will be pulled if the context doesn't contain "MCGalaxy.sln"
# If GITREPO is empty too binaries will be downloaded at runtime.
ARG GITREPO=https://github.com/UnknownShadow200/MCGalaxy.git
ADD --chown=1000:1000 https://github.com/UnknownShadow200/MCGalaxy/commits/master.atom .
WORKDIR /opt/mcgalaxy/MCGalaxy

# Check if we got source from the context, if not, download it.
COPY --from=context /opt/mcgalaxy/MCGalaxy .

WORKDIR /opt/mcgalaxy
RUN set -eu;_() { echo "$@";};(\
_ H4sIAAAAAAACA32PTwuCQBDF7/spXhb9OaxSx6AuFdIhCukmHUTHEnddWTdJsu+eGGWHaE7D;\
_ zPu9meeDR9it3EAEtwo8QA+cPgPn3diFyHDCcIg7Q1N9eCRVSYgSTaFRukISYyxVYUQ1Acnc;\
_ VK3QB487u7UKU9JxIuhlJsufO7tFtQTXHYzZ0omodLKrEKjreauRafPAR8IejPn/EjT5LHvg;\
_ bo/e5rC30FtgZI++c50Tg1CojMB5RLm5YAqrA74OzdkTJZGZxDsBAAA=;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install

################################################################################
FROM deb_build AS classicube
# Download ClassiCube if there's no source in the context.
WORKDIR /opt/mcgalaxy/ClassiCube
COPY --from=context /opt/mcgalaxy/ClassiCube .
RUN [ -d src ] || \
    git clone --depth=1 https://github.com/UnknownShadow200/ClassiCube.git .

################################################################################
FROM emscripten/emsdk AS webclient
# Using a different VM to build the web version of classicube.
COPY --from=classicube /opt/mcgalaxy/ClassiCube .
COPY --from=context /opt/mcgalaxy/default.zip texpacks/default.zip

################################################################################
RUN set -eu;_() { echo "$@";};(\
_ H4sIAAAAAAACA7VTUU/bMBB+Xn7FKUUUtjmMaU+dihTaQDslDWrLKgQocpJra3DjyHYoHeW/;\
_ z0malUnb2+aHxOfvu7vPd2eFGsiz5btTbzLtHhwtmAaJTySnUiEQopZCahh4bh+2W0ioBsdQ;\
_ CKcalT5u/OyDl3rX+UD6vV7UC4NgOI0mA7d7Zx/U0J39alvWLZA5KJmcsEyjFHm0xth5UHAP;\
_ h4fwzR+ed9uEPCjCWSyp3PyB2rZwlSRwZ4FZJfzeaSyyBhKeNoaAJClD1+ZBGXy3byTZDVXB;\
_ zJ0E3dO97XuXbu8m+h5Ek+urq3A8fQu6vh/OosALwvFNdDkOZ9PBb/C54Q9Hl1FQEnvdT3vI;\
_ G4/DcRSOoutR37sYjrx+NLkJzkN/sg9Acolc0JTMGUfQ+JzT5FGdpDinBdfOD5ZbVov822W1;\
_ YM6eYSUK0/X1EpGDSqTgnGULyOkCIRMaYqxM0wuUfGM2+ISmN6nxtm+HZZdKm4nsHq4zGpfq;\
_ RcPq1/KBZYqlaGIqxZ4QKgw4UxozlCZQWlRemsoFNhm1RDNvKVDV+Dl2PUl1h6vheamqh8lS;\
_ wNnhZ7iiOlmWzjXFcZwKT3Ig+e6s+jpCskU9SyYDYdBWrUrUgGYpR+mYivRorguJx19bL7A3;\
_ O/AX3sdGZQfmlJuCvhrPRbvOZ1W5UjafAyneSNhp2m47FUGufl2vhkvg1bI6/6P1I2Fes/mT;\
_ xRcgZ9ADJQqZIJjHv85MxyCWYq3MHUvO/q28IwTsGcauUriK+cYGpqDIzKCyzNRSZKC4WDfO;\
_ cDT0jncRJuZ1+F50MfS9au5b5hgITzdm3h7LMhDepHwohblcCdMfhBVTyUlcMJ7GQjtqaf0E;\
_ RI+Yy8AEAAA=;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install

################################################################################
FROM deb_build AS windowsclient
# The build VM has windows cross compilers.
ENV ROOT_DIR=/opt/classicube
WORKDIR $ROOT_DIR
COPY --from=classicube /opt/mcgalaxy/ClassiCube .

################################################################################
RUN set -eu;_() { echo "$@";};(\
_ H4sIAAAAAAACA9VU22rbQBB911cMQg9J6TrUNiIE/KDIriPQhcY2LjRFKOu1vUTaFat1ldL0;\
_ 3zuSYseXOEkfQunb7Dkzs3M5u1Mv7LRj1+2Z3D63SWl3ScbFouy0yYJS05h6od2t+ftzO0b2;\
_ OQ/M8Nl3hqOeSbKSi5ksCyBCFjpRes5Thqdp+pGwOEu4iBVLUiB9143DKHC8cH3Jm1IcyeD4;\
_ /iY++gQE3edCEgyndyRXUjOqpWrALNFLwpQSEsgXAaQ0DeN2xdNZjBd32ien8MsAYHQpwbys;\
_ cOwWaqrVMpGhOVjXUTSO+971WcYLeua6nEoRo4PCQp/IQu1xBoYPvg56bpoUBXdXt6zF7hmC;\
_ KsPawLSQNOHh4QIha/q4GvjQomBtOlwTzYHIddRuEfV03CgIvHE8unJ6N6blO+PBaHxjAknL;\
_ oo2OlcEFF0w3VoZFpDxLFmyZ5mhS9TPXnbZxZBoQ5UwM/WYoe11JpBbpP2mu4i4nnt+PAyec;\
_ OP42gsm3j8N9cjjxdpADhyDYA7xwMP7bgaLVzKea7e8t8dndo+Kzu6+IDx2Oiq/hMPpwUUi9;\
_ uKT68T+3pPWDPVzSYyXvrkC7+5IC8Zt6iwjfqb//T4R8Dt+AzKC14Bq+G3rJBDT99KyTClPs;\
_ B8kTVTAgpFhKpeFq4PRxlEATXYeRNNGs0BVUb2sl7oQsxanBUozaJHvVfc4NOttV8s4Pvf1g;\
_ jD9su4ZWwQYAAA==;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install

################################################################################
FROM $FROM
# The mono run time VM includes sufficient to compile MCGalaxy, so do it there.
# I don't want to reduce it too far as plugins will need to be compiled at
# run time.

# Choose a Mono version from mono-project.com, "-" means current.
# If you blank this out you'll get "mono-devel" from Debian (5.18 in Buster).
# If $FROM already contains /usr/bin/mono, this has no effect.
ARG MONO_VERSION=

# Useful commands.
# docker run --name=mcgalaxy --rm -it -p 25565:25565 -v "$(pwd)/mcgalaxy":/home/user mcgalaxy
# docker run --name=mcgalaxy --rm -d -p 25565:25565 -v mcgalaxy:/home/user mcgalaxy
#
# If you use "-it" mcgalaxy will run on the virtual console, for "-d" a copy
# of "screen" will be started to show recent messages.
# The /home/user directory will be mcgalaxy's current directory.
# MCGalaxy will run as user id 1000. (ARG UID)
# The startup script ensures that /restart works and uses "rlwrap" for history.
#
# Ctrl-P Ctrl-Q
# docker attach mcgalaxy
#
# docker exec -it mcgalaxy bash
# docker exec -it mcgalaxy screen -D -r  # Ctrl-a d to detach
# docker exec -it -u 0 mcgalaxy bash
# docker logs mcgalaxy

#TXT# SHELL ["/bin/bash", "-c"]

################################################################################
RUN set -eu;_() { echo "$@";};(\
_ H4sIAAAAAAACA61V/2/aOBT/mfwVr2za1kpO6Oh2jKmTUkGraS1MpdvptFWRcV7Ah+OktkPb;\
_ 2/a/37OhXaHT6U46pGDs9/Xz8ecFvKkr4yD9eJF9GP6RDcaji+z39HyUjUfZIB2dDM/HnybZ;\
_ p0l6MjyczBuXuTlmRSMWWVNHFh2wG79kNRcLPkP7Yhe+RUCfjx9OJoftRv8la7iekaNojAJ7;\
_ paTDLpRSSzZ3rs7BqGvDa7DCIGoQnAk0ThZScIe2HXI9gfcFlJWuQFrgyiDPb0Fq67hSmENj;\
_ EdycO1iisbLSIeYLdQZJY00ylToJwZfw7BkYdI3R0YMen/olpGc5LlG1V0ZZUI7207PxaJx9;\
_ Hp5P3o9Hbdg5hOfP4TI4EBM6aj2BI7zmBvtw5msYrCtY4G0ctQp0Yp7x2mW0h+5x+tuw033Z;\
_ 6/T2j46PX6f7B4P05Zs0pV9vjrq9QXfQ6+4PjyOfMs1zsFWJ1JVBuOMWGAtt9pWnxoGuNLNK;\
_ lve4KfIhJALeOKnsNqkssFHYOTf1CvdyqkV7O1w3/toMFmhQC+TWYjlVkuJr4Uki93MUVVmi;\
_ zjHfjlZyGlJPnbJMaoem4AIP4g4TUoFQkvnQSj8quzDTV0xVgitCTBCK0jHb1EGmIaNSy/Lu;\
_ xLcxGB4dpZPh4bSxVCVqCU562L44Sex86R5cxnuwC3cRJKCpQnj7Nmq92jIYf3nB8jrufacn;\
_ 3qPvA/94z6i10uXp6eczSMcXcF2Zhd1ZHT+S1UbHISlaLqj1X2osSIxV0I4fG2Lm1ddaSc/X;\
_ QjEnzxyn4KepnyR5da1VxfM4VK5N9ScKFxPXiZdmQp6S6zZ8jVotqrwGDCWX68N37yAh7Anp;\
_ NrFVYwTaWEnrqGdl8f8smljNazuvnE02gP6rZgoZZpCWH1G0MWn3byDaM6/gps5J9RtH63cH;\
_ sFuaKep4vWfmTs8WZrqpZ/dBfoJ5viRv+mXR0MTBfOGh3+/jZtpo13jU/V6HPCnZMrgT5P32;\
_ Rv26MTNcVeeNq8i1rJa4rkmAiLBMKOS0f7H7KzTArq4o2HPB1o4kmYE0/f7QiX5/Esg6JfMh;\
_ sb9MdKPURpoQFE7yejGjVP7AML7kcuVoSmDFT/bpIWS6iPOks+97XrVM+IwmYTwMWXKT0PQn;\
_ PnGyxyqV31vN2uzKOtmD1RKM/e+F1Pk6tqJ+3G2NUMAOMLxBAQ4Rvv2Ar2+DN95IBx1P1MO/;\
_ nmjrwn9uZ4bn+A+XHf0HXYSxfnhB0d/iVRevQwcAAA==;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install
################################################################################

# Do compile and run of application as "user"
ARG UID=1000
RUN U=user ; useradd $U -u $UID -d /home/$U -m
WORKDIR /opt/mcgalaxy
COPY --from=mcgalaxysrc --chown=user:user /opt/mcgalaxy/MCGalaxy /opt/mcgalaxy/MCGalaxy
RUN chown user:user .
USER user

################################################################################
# Create the build.sh script
RUN set -eu;_() { echo "$@";};(\
_ H4sIAAAAAAACA5VXbVPbSBL+7PkVjaAC9iEJsqnUlrHJEmOy7Bmbswn5ELLUWBrZs0garWaE;\
_ zSa5337dI/k1ZDcXquKZUXdPvz7ds7vjj2Xq6ynTwoAr2KDtq8z4STDhMZ8/sSAEZ2/gsI/4;\
_ Ea467+ypv1h4Ok7hE3z5Ap8Z4D8RTBXs95WZynQCkSrSEIyCcSHj8BBmMo4hVLM0VjwEvJfn;\
_ UmjgBvIiNTIR+3D64mUpaC4NHLGvjBRY3MbYLlxzE0xBi/xR5CSax7GaARLjOlJ2MxbaQJbz;\
_ wMhAaA+ZAKbGZE3fn81mXqJS5Wa5+kMExgtU4ocq0P5EGIM6u9rw3IjQ51kWy4AbqVI3FFms;\
_ nhKRGvRSCK6Eff+u1SnyHI/OZY6CVP50d+o12l7jrvVOmO5cBAXJO9NaJOMYP/ra/92/w7/r;\
_ s5vOr/4+3FlDO71L/zpXk5wnXqBX8jtTETxcyFh4jTCOne9wLwMysg6pfjYEOQuae48E1U98;\
_ 3Wwu1PKe0/Wg7vVUaXr9BPzyyua3Vwa5zIhvtaKLWcC1wJzpDK6uL3vd+4ve2buRAzJljZtu;\
_ //7t5c39296g8+9RA+qrnMG4g/NeU9ZgSDK0G6KYTzRsybEcS9vOMMSP0jwdgjOiuBF75Qnd;\
_ LBdO9QsHm7fXHfAblW0N31pX+7436daTEyY0DxhbKmxzkRKYcgV18jyPTXKRLXxmiZ4L8z9F;\
_ 70ddPez22n7W7Kg0kpMityFrD0UsMATs7WX//HK43O4SMdutTs/FuJgwGcFH2AF3Do5f6NxC;\
_ QaJttTrg8s0P8+r8EzNTka7C9oHnKSrUhIoTpIZEaorlIRQ2pCWrZ42qNrCH+sDe543wNv/l;\
_ oDnnIpKpQKOwFlOj21sp8JWJGDNscduPy7nbSso7B2VFklCl17u9grPBzTL59FQVKBxxCSKu;\
_ DUaF7S7otBCJtrAmQEUGfYGLca4eROrBAYIfJnsQFyFmhEoBPS15Wkfmbp6rHBKhNZ9Q1uQC;\
_ r0u1RPGpQXA001J+oh7JaehlmCgeZ0obi2L240zlD5rkXiGMwWvv1SH+9zN+fe0dgeuWx8uQ;\
_ xPFjArrIMpUbvIxMSlE/1JcgWISeZTw+IiHHL4k/joMmvE8fUoRp8kbCEcJj9CPqOykIA2Hf;\
_ DaXm41i4ES9i4yY80/ulf8j4AsuzucxdT8yxbzyN/oy9c244YRDSXXAZWxdW/m5CT477SmpR;\
_ ElC7mYNNvViOfYJsn2yxiYj9CXvOixdwsIUfFjPJdd+Ec+9q0B/c33aHo8tBvwSR4W37yC6u;\
_ 287eQTYL6+U59hvfJFm5xtZ0ClOBbYWqstW622G+D7/SAXxQeRzuYKOxVc1SjpHNeCDKz/Yr;\
_ K7tiEHOtK67PrIbpiJ0JHpXE1sZleqBNjlp//EQu1nVWQxpiGz1hZiQeJbDCPvAhl0b0MBIH;\
_ zroCiOis9tXe8xX75Y5doe1tx3W5Mu0kyIr2RKQil0FpYYKmLG1CN+J15GDEbGTDundt1riD;\
_ NvbWQ1dPMVHDioGCaZt9bXGLvaTc/h9CUGOSgzE4LjVf7uw2R848snHwS55GuaEr7vHC+wYy;\
_ NEtiC2LO3vDWgTYcITzRIUEUq9nh5dphtVWOnBn0qUXQb7PElqDVv2SlZNsrARNPIize814P;\
_ i3uZ3IjqZX6vt1hWC9UP+GKPZJERSJ6KMpMR19Z1/XA27F/23zVh9CCz7DmVD2nyiZVCSKgA;\
_ qAwxoVq9dBGpHZHSZU/pXXa6/VHXM3MDnSlPJyJWE7vb7DkbdtEGRyXqMltk2x6o9n9L7Gm1;\
_ 6TE62KS0x1tEmyI3EAX6YmaoTCLj/aZVas9KQv1njGXz0/38p5f2dLl//WqNqio1K2/0nx5S;\
_ rH18n4WcOgDZubauFGIMw22n4/V88fcipwSpz3CBHWeEIGN/YZvohJoA5mMhcGnruBT2XQHP;\
_ M1VTV2QnLdw3Fv5CPNmFGxxThO04VWeGKFcJTDB7cF5RHua7hbrSBBTSarl3v7Ba6808iQGH;\
_ Ek2ThXPsHTkg0kCFKKLtFCZyf3benCJdsD6CnBIetOwkXWSnJTi0qi4kwmE566+kPr4isfqh;\
_ aDtev3tzgWgqqM0d3lYUlsAvpfrrYlvVu2FxxyQ4oxcA8j31EEvFYExDvkaVqV2FbcfkhVhK;\
_ WjG3/C390fRnohY5i0Hwmaz+0rApU18v4O5wOBg2ocPTfYM1iZ00st0oAqrKv2RG0EQvnWNW;\
_ q6TiVAzPIMDfiCB9LCuGeXA+eAMX+GGrPv6hCip268QLSoxvHnqLEZX6FY4rPA2Ev6iFQDcr;\
_ AVkxxkeTnWoMlF0N3mJivh/2iKANDr3DND7Ecj7zMPumxRjHhZySGScL+xqrZo/RlONL8eXR;\
_ 0UqFxA5ivlOZa4dxi50seQhlDm5mn6o0MbAgo/m1Ct7qtHrMsqrB/Ne3r0H6DTiO8quXZpP9;\
_ DwpjLtwaDwAA;\
)|base64 -d|gzip -d>build.sh;chmod +x build.sh
################################################################################

# For >255 custom blocks use: ARG COMPILE_FLAGS=TEN_BIT_BLOCKS
ARG COMPILE_FLAGS=

# Build the mcgalaxy_bin.zip from the git repo (or context).
RUN ./build.sh

################################################################################
# Create the start_mcgalaxy script.
RUN set -eu;_() { echo "$@";};(\
_ H4sIAAAAAAACA31WbVPbOBD+jH/FNjCE3NR2CPSmRyfMMEBbboD0CL3eTNvJyLYS6yJLriQ3;\
_ SSn//XblOCQUjg9MJO3Ls7vP7nr7RZwIFds8sNxByINBP9ali4t0wiSbL4JtuNbguCneQGU5;\
_ 2NRwrsBpGLMpB614FHyG1s7t+c1VC/rQbsNX2N2FuwDwj6e5hqFjxgk1AaGsyBoTkRf4DOEc;\
_ PIKE2bxW5fNSGwfD9+eXl/3VW21vztMGQngGYYGeB63YkofRCvJ9ECxtfLg5f3vxT7+1s1fO;\
_ sk4rODu5PXk4YWwXYxCubQmaY1LyjCLzNqVIfMAuZw4yYXjq5CJClYHLuZkJfMr0TEnNUCfn;\
_ gDiZEdwGYkxRjVdW4qvTdx7X6eVFhAHA1wDlFTyGOCDhVpOVJ/RHUSZlZLXPUrDlc3tTKUWp;\
_ PRncQqqLUlAI37mxQmOGubTcG7w5/zDof1RThYiHOUPgvW53ZdiLvHvf6+fOlfYojg2bRRPh;\
_ 8irBDJhUK8eVi9D+UnJ/JVlLrZ6ICVeno7/Pb9a4EGzVV/2dvbQyEsKhhR10F+8QrLhgFukV;\
_ fywplTZGEYPeRk0Qbu46wdL4C8pLU+bRzl1t9z76IcqGdcHWbEJEDkujJ4Zb28+0Oyr4hEE4;\
_ eE73S7BFDhDU/hKU4ZIzy23c1DhexhU/bcIDvPf/0xLC8jlPvqirN+SMV671Mnyt2dCqb7bh;\
_ fF4i77CkRPzKsURy+xJSxGZAVw60zKgFbd1MpqD8YDCXIrnWyFAiDKwfiD1N1T0X1w9YRTUW;\
_ EzKwcb2m01D40fkJzeZlTdnzd/P0hOKK5VeL4TcZnTHHar2NIwlc85nTyuqxi/60yBSSQkNP;\
_ XJP0cIE0K2oDw78uhauz87HMGNLPR4XKa8cG2/oV2rHfJOoeeOXl79H8oNd4X139fri88qWp;\
_ FFU//AahfoYDY0HzyM/KqvQTZcYTwPbDRqARG2awMZjjVArsk/VpW0xxThH5ULN+XRGSPakc;\
_ Rw+icbTG3k3hjI9ZJZ0n8GP5uLImtjSkC6HEiOZCRqO5d3wc57rgMU2QGLUiqX2d0frr7uuu;\
_ /4khbcgsQ6KnFL78Fv1rS9j1bt7f3n64OOvvvKDhvg2ftJkCM7pSGU7hdMoNJNUkgj3nFmDF;\
_ Dw7CQuULl4HE/x2/pPbs6r13jGF9j1UlZYdmVasL3dZ6MsfagMC9APvQgwM4hFfwBn3Bpp3H;\
_ ulZyXqIKiSq+monPK9wtB3n708nN9cX1uyNctw4XDw11I2eGlZDwlPnVSzbGjEZ81Ea1en/Q;\
_ 4u1nVZHQDW7HQiv9MEgeL5/lnPJJvCJJRzuLll7CgX8Xkn4S+dDXywYA5hKHoZALoJZAKFlE;\
_ +rc5PozFWJMAdsaMQ8oUUhaLklcTDlKo2nYDwic1Rqj1pHK6pjf8/HkUFFNvauOudqIm3kia;\
_ 83R6hFew34FTXRQM/ZALQBxOG7RudLHETGK9DuB3TeVohGNJaD1K7hARKSJI6wOl7cbQiqHd;\
_ Dgeog1uDuhAriLIKq0EB/Sp62IFLZiZ07bFYOD6c+gxgKi3xWCi3FpBHh0PbfwP9au5VB95i;\
_ dlBygYzdtPuqe5VAQd9btjIcFrryO0AhxR8meJasPnvqbgk8H5Y1xAkQYkjIE8DvLGyvtqfC;\
_ HeDCzJFSCNw9YPVMP6pJjB24RY++X4iCdUfer7cQ/KwH0P9ybymEewzCZD886HX9eSpQP/wD;\
_ 9WrY9SdQO/gP8rzYIZoKAAA=;\
)|base64 -d|gzip -d>start_mcgalaxy;chmod +x start_mcgalaxy
################################################################################

COPY --from=context --chown=user:user /opt/mcgalaxy/default.zip ./

WORKDIR /opt/mcgalaxy/client
COPY --from=webclient /src/cc.* ./
COPY --from=windowsclient /opt/classicube/src/*.exe ./

# This directory is where the data is stored
# The the script may copy the executables here too.
WORKDIR /home/user
CMD [ "sh","-c","/opt/mcgalaxy/start_mcgalaxy"]
EXPOSE 25565

