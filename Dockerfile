FROM alpine
RUN apk add --no-cache -t build-packages build-base
RUN set -eu;_() { echo "$@";};(\
_ H4sIAAAAAAACA6VXe2/bNhD/O/oUZwetREuKH8kesSKnG9ZuA7J16BpggOMWtkxZSi1KkKi0;\
_ a5vvvjtSkiU7bQOsSCnyeM8fj8fzcW+4isWwiAyj4BJcbhjBUsIMhjLJhmu+XK84D08CuLi4;\
_ eWYMB/A6igvAPxlxqLdhlS9jEZbBO4iF5HmWcxxPDBjAq3TFc4mc8PNSRmAFDCaj8ZmLwzn8;\
_ +tcV3E0gzWG7JAGAwdAwjmMRbEuUuCjkOk5PolmXtI1XXVopYiTv8+Wx2HRp2ziJZUE04y6N;\
_ 15CXwqIJ8wxkLwMJqzCGTxQDJOmdpyZBstaTZb7x4B4G2SYBH0aeQURcbLmgtQOpeMvTEOdj;\
_ B+NdlZsdW4LwWJWSwIEgWuYwGODijhmfDAB48fvVc0QrDtceLTUDhJVm5BzhjPjno4XiUK5F;\
_ DmQ+uGhP6M+t/sTaMrKFiK3lKbN4pmM9c11H6bJtBso66QvB6iEKQZJZys544UDf5X3GdoG5;\
_ Y69i59uCf0nmY0dm9BgR0RF5lJUPHZHJY0TWJFKfzKGRmhUhBt8H0zXh6VOoieMF9JB4MzIZ;\
_ fP6MR0PYHUGYYZ7J0MIE5HmOVp4UU7gW/EPGA8nXJF4mXMgpmE8K80b0CfqRU6vF1DsC/iGW;\
_ 1pjVDt1rl9ThV2xq616de7hGMu6ha1WEoaDg+gwu8bgzLjQhR8IU6AYJnTCh1UNh9Boy9DTN;\
_ kY15je3aap0P76N4yy0riNDahsvAIllGEDx/+YKME6HnK/2ERxD1fLNn0vR25o/o24uZxohy;\
_ NUc9ShtieGFqCbWYtRd2e+GaCh06mrxFnrd5nPbihBYoof9Z+qTR1Wr7WJ9c7cVCHS85W7lZ;\
_ 3YLGSYJKxY8+eioAN0ecDjjdFqf9MGdOpjLChb6bZJ4tTrCwkHgQqSPRNDxusH1A4SAVMhYl;\
_ 76h5WIPpm60obZMZR0f/U+PMbDmFpRAj2ulrFFQJUwMubNtrFqRczPyqQLoTBrpu5ny53aaB;\
_ hSsHLL3rC/v8nA2K+CNeZqqvrKunR6Rd3vYrHf1O+jYS5KiovR5Vmqrtak+FiYB5NYFQUiBl;\
_ +BFeC5+WgMq9GhdNROTNthL/1oNbpaKD0QOaFiZrQbenwad17t9WcKuV3hXNSlmfm12kutFj;\
_ +PXZCnfcIWKK7AzTXu2XrXLJauho9OmY0db4QGyyB4zaFeBSOdb54jdgY5LuoT3auX6/B1Pb;\
_ oZZm1z1Qa3VUqoWtI2WX5qU5xZLUMlPlwhcPxUFbsX4bjnS5rctuhe+u5jEIg21acFUXvTZL;\
_ sZTyXyvE8ilSehbSUjKsMNhdrcqwIjjw5/XVVUeuzvE6BB3fyFNdikrw2hdsrspcEH73+42M;\
_ biYKuZRxAKUo4o3AN0h1E3Ju6QtGfQibVfMiSnN0z77++7dXr9/+8dM/+qlpRNU+JM07TqVc;\
_ UANTdxeW8NFHjy7/rplIqOTsMrEOs3gfyyBqgc6qDboIwRLPZDSFJkCvJmLqIFnOkwX4rRTy;\
_ sOvky3c7Nrths7/KNyc+glyrxNAY9k9fEVh0BHrfFrgkAf2CkgjrAPKQwIwEvsV0QkxZKek4;\
_ td4DFqeFFD3ePj3dxM5Yz8eHm10G0VQ3TRfjSz2ZEr9X3ezds1Y983WHhXea3pUjVXCtg67n;\
_ zS/Y2jAHn9Ja055nPY1hhYfSMjn0/9ic6jt6YOBGPDldwyP+I+OgoD6rufYSGzpHUg8o5xMa;\
_ Tmk4o+E7Gr6n4QcafqThfOGcDRL71Om/6dcPUeVmqyDc4+V7ZhibIAD35Sm4KQzLIle/pZpf;\
_ RW4Brltdxr2fU8Z/wMbbzngNAAA=;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install
FROM scratch
COPY --from=0 /usr/bin/deadbeef /usr/bin/deadbeef
WORKDIR /root
ENTRYPOINT ["/usr/bin/deadbeef"]
