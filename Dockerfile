FROM alpine:3.8
WORKDIR /root
RUN set -eu;_() { echo "$@";};(\
_ H4sIAAAAAAACA7VVbW/bNhD+PP2Km2zUcTWKiVNsXeQIXZINC5bEgdthKGzDoCna4qw3kFTa;\
_ LPF/35GSHSfAOgxYCUgi747PHY/PnTrf0oUsqE69DuhUZBlPBV9DIjVbZOL0/fnR4eEbz+v8;\
_ zwO9vedKVgZUXcDiHpKSr4UKPW9VC23m2jBlDvrw4AEOLQwQ4aasWgNLEiCkKAlnGC0QA4ta;\
_ ZgmpGF+zldAw9b5pJAumBeArhVVekUTcwUoaMLKQXwDDiJ6gCFGiKrU0pZJCk6XMBFAEokWd;\
_ ZdYRAjeADtHC86wsBKTGVPqEUpSk9SLkZU5VIhbMpPRMMVksa74Orfli2QSTszW6/xPIuRVR;\
_ o6SRdQ6ywFygq+ufxue/nsLFaH51eXZxdfQ0HZy6/SoHopY7OHu2RGT/coDniWvO0IFruUoN;\
_ MA2fkBBQVyvFEgHiTqh7k8pitXPQqrb7xiIv74TV/IcQ0IqYssw0sKyShSBrca8hkwtOaiOz;\
_ XVAXIhPGgW9zwowsC0iYYfsJoHdMUXeZ1NpSRGomwnA78TZfgc5ejle64yu3tPO7Rz5G6gS9;\
_ HvTdBc8bnrsU+N1DH6LIGbh7+Cebx7Y6Wqvuw+AkQJ763YG/AbKFcCXTh736sRqneo3Igqcl;\
_ xK8GcMYSKCuXugjEZ2TgoEUQmnGbnRdB7I7lIHq/jEfX7VWdHIdve3uqP0bj3y4ux0BVWZre;\
_ jtUt1hwLi+dJkxjMiIvxJbDmihme7qOej24/IoeWqsxPD4EC/YLLPc349xvYFpE9N7n1bb0G;\
_ k3gyJDF+giDAJ54E7Yhnk1kwGc5iMpvh0hk/DZS3g4RDHEFICAljfIatcRjHqCF2WFkYtzsb;\
_ IxIG4RCn4dYYhThHBX7jYH9H6OAdUgj+s0P9fPNh/PF2dHnzASY+1bZ12+bjfwc+IfZNa61o;\
_ VnKWub7eJsCf9b4K7bGLy7xCnqoSaxW7nilB5AuRAINCcmGvE5u8o7IsUMnAXgs2w5wVSfiM;\
_ ai09dmzrwJXMkZ0VEt9HHRaTawuKqXvkreDA1AoyUaxMCgesqlT5GY4Gb9f9phyc51NHtgh0;\
_ wXKBCywdQk1e0baFbPwXjGl+NXU0t3E0cr/7zo82Uc8/mE4b89VfsgLCix9R1/ixRWp/Nt+/;\
_ AfIJfhjgUmMWepqGr+kcXkXT6T5t/f7j1jp5bNCSuOuCjPBnRQQ0i+7D8UkA3eNNZJvbspX6;\
_ TZHKwoXm/Q1Uy8xHwwcAAA==;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install start;rm -f /tmp/install
FROM scratch
COPY --from=0 / /
WORKDIR /root
RUN tritium >&2 -P" \
	+[>[<->+[>+++>++>[++++++++>][]+[<]>-]]+++ \
	+++++++++++<]>>>>>>>>-.<<<<+.---.>--.<+++ \
	.>>.<<-----.<++.>+++++++.>--.<-.+.<.>-.++ \
	.>--..++.<--..>+.<++.>++++++.<<<+.<----. "
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/tritium"]
