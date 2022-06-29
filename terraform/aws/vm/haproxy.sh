sed '$ d' /tmp/haproxy.cfg > /tmp/haproxy.cfg
sudo cp /tmp/haproxy.cfg /etc/haproxy/haproxy.cfg
sudo systemctl restart haproxy
