H=root@linux3

./ovpn-build.sh | ssh "$H" docker build -t openvpn -
./ovpn-build.sh openvpn/a-and-o | ssh "$H" docker build -t openvpn:a-and-o -
./ovpn-build.sh openvpn/eviivo | ssh "$H" docker build -t openvpn:eviivo -
./ovpn-build.sh openvpn/tenables | ssh "$H" docker build -t openvpn:tenables -

ssh "$H" iptables-legacy -L

ssh "$H" docker run -d --restart always --cap-add=NET_ADMIN --name ovpn-tenables -p 5006:5006 openvpn:tenables
ssh "$H" docker run -d --restart always --cap-add=NET_ADMIN --name ovpn-a-and-o -p 5005:5005 openvpn:a-and-o
ssh "$H" docker run -d --restart always --cap-add=NET_ADMIN --name ovpn-eviivo -p 5001-5004:5001-5004 openvpn:eviivo

