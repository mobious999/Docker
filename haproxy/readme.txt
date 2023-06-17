sudo yum -y install haproxy
/etc/haproxy/haproxy.cfg
sudo systemctl enable haproxy --now
sudo systemctl status haproxy
http://localhost:1936/stats