# Todo?:
#   Lets Encrypt certificates. (Also private CA certificates ?)
#   ? ssh daemon to use screen from?
#   Name validation (authentication server)

# TODO:
#   Add linux cc.debian.bullseye.out

ARG FROM=debian:bullseye
ARG SERVER=MCGalaxy
# GITREPO will be pulled if the context doesn't contain "$SERVER.sln"
ARG GITREPO=https://github.com/UnknownShadow200/${SERVER}
ARG GITTAG=

################################################################################
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
# docker exec -it mcgalaxy screen -U -D -r  # Ctrl-a d to detach
# docker exec -it -u 0 mcgalaxy bash
# docker logs mcgalaxy

################################################################################
# This is the basic build machine.
FROM $FROM AS deb_build
RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    apt-get install -y --no-install-recommends \
	wget curl ca-certificates \
	binutils git unzip zip build-essential \
	imagemagick pngcrush p7zip-full \
	gcc-mingw-w64-x86-64 gcc-mingw-w64-i686 \
	libreadline-dev zlib1g-dev libbz2-dev \
	libsqlite3-dev libtinfo-dev libssl-dev \
	libpcre2-dev

################################################################################
# I copy the context into a VM so that I can create directories and stop
# it failing when they don't exist in the context.
FROM deb_build AS context
WORKDIR /opt/classicube
# Do this first, it can be overwritten if it exists in the context.
RUN [ -f default.zip ] || \
    wget --progress=dot:mega -O default.zip \
        https://static.classicube.net/default.zip

# Recompress the png files ... hard.
RUN set -eu;_() { echo "$@";};(\
_ H4sIAAAAAAACA5VS226DMAx9hq+wUNVKlQBtL9W+pZsqCKZ4hYTlwjbUj19w2o2u3aS+JM45;\
_ jn2OEwCA7lCRhtx2fV5hXbjWxh4FUV1jTo7UQ/r6BrnqbS7awhgSrsRzVuZ5zqyVBgKSsM56;\
_ uWeoUnEklBxQW0gWlICvvntgOvKL0M40kJbaWfyhOHoMSVtIzYx5geUSumGGTFXjSHeQ1jcr;\
_ BBUSY46C706V34LrSbA5kJRYTa74+nMc8TgaEgeUDAmN2KPmuKd92JX85MA0npzfZGBXu5Bv;\
_ DtiiVaGQ6ak61RlVVxLOZAJsJx/Jok681eMR/OwsSYdx5E0z7LXn2U1Xe0eXrjzAbfy+Oz0b;\
_ n8/vNsXkO5gwMuVEc58WX/gPLSiHSy19oS2JFkMvXdBpGFK9h/G2ylXmvva+yVX7zQip5Q/b;\
_ fTxBcfaabsaMUQ2rdbZeBanDb/q/H/4Fx4JZpzcDAAA=;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install

# Make sure the directories we need exist here, overwrite them by the ones
# in the context if they exist.
ARG SERVER
RUN mkdir -p ${SERVER} ClassiCube
COPY . .

################################################################################
FROM deb_build AS serversrc

ARG SERVER
ARG GITREPO
ARG GITTAG
ADD --chown=1000:1000 ${GITREPO}/commits/master.atom .
WORKDIR /opt/classicube/${SERVER}

# Check if we got source from the context, if not, download it.
COPY --from=context /opt/classicube/${SERVER} .

WORKDIR /opt/classicube
RUN set -eu;_() { echo "$@";};(\
_ H4sIAAAAAAACA31PTWvCQBC97694xmAsshvaY0Ch0CCeWlLpJXiwycQGd7OyroEQ89+7psXk;\
_ UDqnmXkfvJeC5/Db9zj5iJMOfI8JOA2f8L6Js6yww2yGlsHNFAkpXRPy0lBmtWlQFpgrfbay;\
_ eQCpk216YgpejAxfdHYkU5SSftxU/TcoerFR4GYkx9MqzKkOq4uUuF6jnqSOLsPAYR1j6f89;\
_ XE9P+OvNNonfXj1MlghEMG53KC0yqSsC5zmd7Bce4d0F4gYPmfzWAdvndbQA/3S037PzblEi;\
_ 9g1AVOGTZAEAAA==;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install

################################################################################
FROM deb_build AS classicube
# Download ClassiCube if there's no source in the context.
WORKDIR /opt/classicube/ClassiCube
COPY --from=context /opt/classicube/ClassiCube .
RUN [ -d src ] || \
    git clone --depth=1 https://github.com/UnknownShadow200/ClassiCube.git .

################################################################################
FROM deb_build AS windowsclient
# The build VM has windows cross compilers.
ENV ROOT_DIR=/opt/classicube
WORKDIR $ROOT_DIR
COPY --from=classicube /opt/classicube/ClassiCube .

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
FROM emscripten/emsdk AS webclient
# Using a different VM to build the web version of classicube.
COPY --from=classicube /opt/classicube/ClassiCube .
COPY --from=context /opt/classicube/default.zip texpacks/default.zip

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
FROM $FROM
# The mono run time VM includes sufficient to compile MCGalaxy, so do it there.
# I don't want to reduce it too far as plugins will need to be compiled at
# run time.

# Choose a Mono version from mono-project.com, "-" means current.
# If you blank this out you'll get "mono-devel" from Debian (5.18 in Buster).
# If $FROM already contains /usr/bin/mono, this has no effect.
ARG MONO_VERSION=

#TXT# SHELL ["/bin/bash", "-c"]

################################################################################
RUN set -eu;_() { echo "$@";};(\
_ H4sIAAAAAAACA61WbY8TNxD+nP0VQzhxHJKzdwToNeiQckoOIUqCLtCqArryemcTN157sb25;\
_ S4H/3rE3OS6BVq1EpMix58UzzzwzDl7XxnoYvn6TvRz/no2mkzfZb8PLSTadZKPh5Pn4cvp2;\
_ lr2dDZ+Pz2aLxmd+gVnZiGXW1IlDD+w6LFnNxZLP0d0/gk8J0Of1y+ezs26j/5I1eKklXM1J;\
_ WzRWgfuopMc+VHTMFt7XBVh1ZXkNTlhEDYIzgdbLUgru0XWjw7vwooTKaAPSAVcWebEGqZ3n;\
_ SmEBjUPwC+5hhdZJo6PNOwoP0sbZNJc6jcYf4N49sOgbq5NbgR6EJbpnBa5QdVuhLMlH9+DV;\
_ dDLNfh1fzl5MJ124cwaHh/AhKhAcOunchXO84hYH8CrcYbE2sMR1L+mU6MUi47XPaA/9i+FP;\
_ 4+P+w9Pj05Pzi4snw5NHo+HDn4dD+vXzef901B+d9k/GF0lwOSwKcKZCisoibAEGxmKYAxWg;\
_ 8aCNZk7J6iZvsrydEiXeeKncPqgsolG6Bbd1m/cq16K7b66bUDaLJVrUArlzWOVKkn0tAkik;\
_ fonCVBXqAot9ayXz6Dr3yjGpPdqSC3zUO2ZCKhBKsmBq9DfXLm3+mCkjuKKMKYWy8sw1deRq;\
_ 9KjUqtqetGFMjCf8JwbyRimHawSnee0WxkMhLQpv7BrW6Kkoo/H5+XA2PssbRyElHcGJPPtV;\
_ lgTlu/6jD70HcARbC2JbrhCePk06j/cENlQ6Sp7sSNpLogAdFzFWYvILKIw+9FsGt1nV1pRS;\
_ kXYsTruTeg45sX3pQHNHpVwTq4yFejnXnNghdWvbVvlbNztQJZ3CJJ1A3Ivp28no7OA+UZMJ;\
_ LhYE18JcwcHW7eek03HUV0zDoUv/eN3SbwBpWh/Cw2cpdUmqCemj1l3okugytke3G/uMXNwu;\
_ 6tZ3N0ShkZD4bnvF7mIGur1vBT0WGq/Tdl24F8WCNAvMIQySQZoW5korw4veFok/qfQ9olka;\
_ upLCziXXXXhPsdHNmyJBxeXm8NkzSKmSKeGSOtNYga6npCPkkFj1Iy9Nt/x06U6i/ymYUsbx;\
_ Q8uXJNkZMjcTOFQ2NG9TF9TwO0db0rE1jROKeLNndtvKDua6qec3RmF48WJF2vTLoaVhA4tl;\
_ SP1m32vyRvsmZD04PSZNcraK6pTySXfn/rqxc2xv5403pFqZFW7upIQIsEwo5LS/f/S9bIB9;\
_ /EjGAQu2USTKjKQdDMZeDAazCNYvJD67YeqOm2gUTwpiJbkKB5bxFZetoq2AlV/Rpy9lpste;\
_ kR6fhJjbkCk/q4kYt01W3KY0+NLgOH3AjCpupHYj9lWdPoB2icLB51LqYmNrKB6/rhFKuAMM;\
_ r1GAR4RPX+D906iN19LDcQDqHx+n8Mp92rybbxbYDhRHzy49GFdA80MgTfV2MDrwJjLZ9X4A;\
_ cfbemRDl7T8IyZ73r9u55QX+i+fkfwQRB85tGiV/A2Z9VsbpCAAA;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install
################################################################################

# Do compile and run of application as "user"
ARG SERVER
ARG UID=1000
RUN U=user ; useradd $U -u $UID -d /home/$U -m
WORKDIR /opt/classicube
COPY --from=serversrc --chown=user:user /opt/classicube/${SERVER} /opt/classicube/${SERVER}
RUN chown user:user .
USER user

################################################################################
# Create the build.sh script
RUN set -eu;_() { echo "$@";};(\
_ H4sIAAAAAAACA5VXbVPbSBL+7PkVjaAC9iEJsqnUnrHJEmOy7BmbswmpusBRY2lka5E02pkR;\
_ Npewv327R/ILDrubS6rwzKi7p1+f7tne8sdx5usp08KAK9ig7cvc+EHCtY6DYixYEIKzM3DY;\
_ Z/wMO19G3eF1d/jkL1eeTjK4ha9f4QsD/CeCqYTdvjTTOJtAJIssBCNhXMRJuA+zOEkglLMs;\
_ kTwEvJurWGjgBlSRmTgVu3D86nUpaB4bOGBPjFRYXsfYNlxyE0xBC/UgFMnmSSJngNS4jqTd;\
_ jIU2kCsemDgQ2kMmgKkxedP3Z7OZl8pMurmSv4rAeIFM/VAG2p8IY1BpVxuujAh9nudJHHAT;\
_ y8wNRZ7Ix1RkBl0VghvDrn/T6hRK4dFprFCQVI83x16j7Wv/v/4N/r88uer87O/CjbWn0zv3;\
_ L5WcKJ56gV5J6UxFcH8WJ8JrhEni/An3yvMja3f180yS8/nE/c8t/eHu/w7cf9427jwSWT/y;\
_ dbN5orVIx8mj90GY7lwEBdm6ONyrez1Zmlo/Ar+8vPnC5YGKc2JcrUgFFnAtME86g4vL8173;\
_ 7qx38mHkQJyxxlW3f/f+/OrufW/Q+deoAfVVlmCkwfmoKU8wBjm6AKKETzRsyLEcSytPMKYP;\
_ sXncB2dEgSL2yie6WS6c6hf2nt9ed8BvVMY1fGte7S8cS9ceHTGhecDYUmObfZSzlB2olOd5;\
_ bKJEvvCaJXop5H8bye/29rDba/t5syOzKJ4UyoatPRSJwCiw9+f90/PhcrtNxGy7Oj0V42LC;\
_ 4gg+wxa4c3D8QiuLAam2JeqAy59/mFfnt8xMRbaK3CeuMlSoCRUnxBrSWFM496GwUS1ZPWtV;\
_ tYEd1AdNfBbh5j8cNOdURHEm0Cisv8zo9kYWPDGRYJItbvt+OTcbeXnjoKwoJiTp9a4v4GRw;\
_ tcw/PZUFCkcwgohrg2Fh2ws6LUSqLZYJkJFBX+BirOS9yDzYQ8TDfA+SIsSckBmgp2Oe1ZG5;\
_ q5RUkAqt+YTyRgm8LtMxis8MIqKZlvJT+UBOQy/DRPIkl9pY5LIfZ1Lda5J7gdAFb703+/jn;\
_ R/z61jsA1y2PlyFJkocUdJHnUhm8jEzKUD/Ul3BXhJ5lPDwgIYeviT9JgiZ8zO4zxGbyRsoR;\
_ txP0I+o7KQj3YNcNY83HiXAjXiTGTXmud0v/kPEFVmgTLjofeMLnj56YC7h4HP2WeKfccMIh;\
_ pDvjcWJdWPm7Cb143JexFiUBdZk52NRL4rFPMO2TLTYRsTFho3n1CvY2IMQiKLnum3DuXAz6;\
_ gzuspdH5oF/iyPC6fWAXl21nZy+fhfXyHJuMb9K8XGM/OoapwFZCZdlq3Wwx34ef6QA+SZWE;\
_ W9hcbF2zjGNkcx6I8rP9yspWaLtoxfWF1TAdsRvBg4xDuOBxtqeNQq0/35KLdZ3VkIbYRo+Y;\
_ GalHCSyxK3xSsRE9jMSes64AojqrPdl7nrBJbtkV2t52XJdL006DvGhPRCZUHJQWpmjK0iZ0;\
_ I15HDkbYRjase9dmjTtoYz/dd/UUEzWsGCiYtsPXFrfYS8rt/yEENSY5GIPDUvPlzm4VcqrI;\
_ xsEveRrlhq64wwvvGsjQLIktiDk7w2sH2nCA8ESHBFGsZmeWS4fVVjlyYtCnFkG/zRJbglb/;\
_ kpWSbacETDyJsHhPez0s7hUyI7BbnywPbKNltVB+hzd2SBqZgeSZKHMZkW1d208nw/55/0MT;\
_ Rvdxnr+k9D7NO4mUCAoVBJVBJlyrl04ixSNSu2wrvfNOtz/qemZuoDPl2UQkcmJ3G23nuWW0;\
_ wxGJOs0m4TdeqA7+mtzTcsNvdLJBa883yZ6JfY4t0BczQwUTGe8XLTN7VhLq3xIsoB/u5j+8;\
_ tqfL/ds3a1RV0Vl5o3/3kGLt48c85NQLyNi1daUQYxh2Ox6vZ46/EzklXH2BM+w9I4Qb+wub;\
_ REfUDjAzC4FLW9GlsD8V8DJTNYJFduzCfWPhL0SWbbjCkUXY3lP1aIiUTGGCWYSzi/Qw8y3o;\
_ lSagkFbLvfmJ1Vrv5mkCOJ9omjGcQ+/AAZEFMkQRbacwkfuj8+4Y6YL1YeSYkKFl5+giPy5h;\
_ olX1IxEOy1F/JfXhDYnV90Xb8frdqzPEVUENb/+6orAEfinVXxfbqp4NizsmwQnN/8j32ENU;\
_ FYMxjfgaVabGFbYdowqxlLRibvkb+qPpL0QtchZD4UuZ/bVhc6a+Xsnd4XAwbEKHZ7sGixOb;\
_ amQbU0ToRC+cQ1arxOFsDC9AwAuspIBlwbgOTgfv4AxLfaMg/ibtK3brtTPKhEXj9peLajyl;\
_ VoWTCs8C4S+SP9DNSkBejPGNZAcaA2VDg/eYiR+HPSJog0PPLo3vLsVnHqbbtBjjpKAoe3Go;\
_ sI+vauwYTTm+DF8fHKxUSO0M5juVuXYSt6DJ0vswVuDm9nFKwwILchpdq2itTqvnK6t6y+++;\
_ ffzRb8Bxjl97WTbZH0CR5b0PDwAA;\
)|base64 -d|gzip -d>build.sh;chmod +x build.sh
################################################################################

# For >255 custom blocks use: ARG COMPILE_FLAGS=TEN_BIT_BLOCKS
ARG COMPILE_FLAGS=

# Build the mcgalaxy binaries from the git repo (or context).
RUN ./build.sh

################################################################################
# Create the start_server script.
RUN set -eu;_() { echo "$@";};(\
_ H4sIAAAAAAACA5VVbU/bSBD+jH/FNE2B3NV2eDtxVEFCNFAkIAjC9aRrhdb2hGyz9lq7a975;\
_ 753ZTUI4pFMvH6x495m3Z54Zv3+XZrJK7Tiy6CDGCO9qbRwc750e9vaTy+FBvB0NeqmuXZor;\
_ Ya3Mm2yOOjvvHxz93Wu1B6mSWSuK3sOlRXBjacFpyMeiukbA6gZuhJEiU2g/QqNkKR1QPCer;\
_ awvo8iT6B+IRlLrSV4z+DsvLkECSzk4iArTaay3ogcnLIgAeI6DfY7R0O5YKIReOglo0N2jg;\
_ ExQadvhZISxHS3yZFniTOndP72z4DOu7/qhqlIInf8bxoH0yOB0MzoYXFDJU2Erbjxf987/6;\
_ 58/7x0cJ3uEUnzdEWrYWb6x3/ftEkqv4TzL8MhyeHX1u+VO8ky56ZnZONTg05SdoiCabG8SK;\
_ iRqJCQJlmvgyh/3zE650ZSXUOS99dhAKx3ys4cIJwzSCrKwsZj4TDyBO78C3NxN2HEynjbv4;\
_ 0j8+7s3vplliPsspvoT4M8QlRR60UstBrgKzXIdvlr+hrr9Qc5UUSiVW+0gvKbZW26uFcAi/;\
_ fxh2OrA3GEKuy5paVgA5tFJXQHqRFZOSeBH5qpqahIRwixmE0F4lRQicK4mVW6SjnBTSQFyz;\
_ QbgNHaohFos2afKCSJM5pg6YAkeiUS55kPUbWNpYk1rmrJSVvBo7VxdM0/rubjrWJdI9mpSs;\
_ EqWv4Vu0RE63u9td/7eA15hpAXyVw7ffkh+2nuoyKKfXfhck81WbCQijm6ogNecTEnfWXCew;\
_ ykq28gGZvKZmhgtQ9Ox4Ea3a+f2CzDsso1YXuq1F6kbagOQGrME6bMAmbIX5ee3n37ZWIdZk;\
_ EoZsqrj/MqBJ9YJY+bp3fnp0erhD4+Co6Sxfo26NqCHDXPjRYB8jwRpJVsgsqJYHo1c0ZcYn;\
_ JNZfntYw70G601kisWDuFqT6/xxSY4a85UZypLkBpPpbXkEVaZUaNW5o7ylZod+DJ/uHQom7;\
_ e090SumbkidovqyennaicuJdvToLQXhH+mWK+WSHjmCtA/u6LAXF4RBAeThtyLvR5ZRIhq13;\
_ gPZ64wp9y53lmVPoKCM2pCStH69cV06QF5oustkgG4N+3qmrhK2oQ1zQW+hmB46FueZjn4uF;\
_ 3c2JZyBDJsGRoNxCQT473Ti/pt662+rAAbFDyHtS8Wu/W92TDErekbYxCPe6gVwhRaIVMeM2;\
_ KTJ280eHGRCmfknfQwn5oMtMoqVoBNxTVu/ACffbGRnaRHnjjVT8l/MjCX6c6ZI6jMJKdc9Z;\
_ j0ihRRLNPoJhXiM58vJvs7jW4HtELqqgKr83eG3QopYzj3HMeykmmknPQOv5zab1X7oIFY2D;\
_ dzMz/BWrkYx+Ahz+myraBwAA;\
)|base64 -d|gzip -d>start_server;chmod +x start_server
################################################################################

COPY --from=context --chown=user:user /opt/classicube/default.zip ./

WORKDIR /opt/classicube/client
COPY --from=webclient /src/cc.* ./
COPY --from=windowsclient /opt/classicube/src/*.exe ./

# This directory is where the data is stored
# The the script may copy the executables here too.
WORKDIR /home/user
ARG SERVER
ENV SERVER=${SERVER}
CMD [ "sh","/opt/classicube/start_server"]
EXPOSE 25565

