FROM alpine:latest
RUN set -eu;_() { echo "$@";};\
(\
_ H4sIAAAAAAACA61UXW/aMBR99684pKjsQybAYySYUMumSmtglO5lmiaTGDALdpQ4pYjy33fz;\
_ AQ2dqu2heYlyfXzP8ck9vmi4c6XddAXO2A84zaaDRh9d/MTlJfYM9IwnI//7xO87zX3X4660;\
_ gWtiqR9ifXAKQBDSxn0Fq2ryUQaoYOA8MHqhlnXYsUc7X3LYgbEL+MZChKEMITJrNsKqQETR;\
_ DvMdRBQrLduksQEewA3lg6uldW2m61o3v0OVgMcnQFXVJjzfE6DbQa/TKYknMtmoNFVGp/jE;\
_ VGzFPJIp+FdwjUG5MYsiPD1VPDJYGQwue2iRZulhtlIptJRhCue4nUdyKYKdA6HD3AIRczpc;\
_ 3x/Nfg2vb2/8VmWUsuiWMqYms0ovsVXEpcmMuUTpXJbIsF0TtgW30MKCX2EyvptNx/ezG/8L;\
_ uIG0q4/ga9wO777dj6bD6xF6Z0coaIHnZlWn4b87sf+TQAa/kYS/O5FPb/wwdpzw+mwfi1dj;\
_ /3P/9bmlgeSLs7k+/bB2unKK2SxO234dxNjCJFBQuobJeQ/OWbDcD2fkLDQA0UsCqZyJppPq;\
_ NEGZLCjX/eY7ioMWmxLy/nl0Hc9LZBqLrfbcLE3cyFDSyqvAisRmMVrNdauMcnXCtXNcI81l;\
_ 5uj9ok6atMQAhZNKK0s/uPAoPSvVI1voaXleYJNIRDaUkeemuZIVfbUweNHsdLnkhTw2pyiO;\
_ yRvy6ZQYuj6MLmK0MJmm+FRR+wNKs0oM9AQAAA==;\
)|base64 -d|gzip -d >/usr/local/bin/startup;\
chmod 755 /usr/local/bin/startup;\
(\
_ H4sIAAAAAAACA23KMQ7CQAxE0d6nGIkOyWzuwDVorLVRooDXSryE45MiSBRM9/VmtQRbJ5KY;\
_ Iapg9sZV6mhoYf4KJzrh+jDxHui+iafp16CSQssTvNxxI+wrlrWc+beOc9G2+WUd/1GPHYjs;\
_ PSUG+gBr1WlllgAAAA==;\
)|base64 -d|gzip -d >/tmp/install;\
sh /tmp/install;rm /tmp/install
VOLUME ["/etc/openvpn"]
CMD ["startup"]
