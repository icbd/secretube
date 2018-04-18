```
export LC_ALL="en_US.UTF-8"

yum install -y epel-release centos-release-scl yum-utils
yum install -y https://centos7.iuscommunity.org/ius-release.rpm
yum-config-manager --enable extras
yum-config-manager --enable epel
yum-config-manager --enable ius
yum-config-manager --enable centos-sclo-rh
yum-config-manager --enable centos-sclo-sclo
yum repolist

yum install -y openssl git net-tools lsof telnet nc wget curl htop lvm2 device-mapper-persistent-data

yum install -y vim
touch /root/.vimrc
echo "set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936" >> /root/.vimrc
echo "set termencoding=utf-8" >> /root/.vimrc
echo "set encoding=utf-8" >> /root/.vimrc

echo "alias ll='ls -alF'" >> /root/.bashrc
source /root/.bashrc


gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm --version
rvm requirements
rvm install 2.4
ruby --version
gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/
gem install bundle
gem install rails


yum -y install nodejs nginx
systemctl enable nginx
```


```
mkdir /var/www
cd /var/www
git clone https://github.com/icbd/secretube.git
cd /var/www/secretube
rails db:create
rails db:migrate
rails secret
```

copy this key to `config/secrets.yml`



> /etc/nginx/conf.d/secretube_tk.conf

```
upstream secretube_tk {
  server unix:///var/run/secretube_tk.sock;
}

server {
  listen 80;
  server_name secretube.tk www.secretube.tk; # change to match your URL
  root /var/www/secretube/public; # I assume your app is located at this location

  location / {
    proxy_pass http://secretube_tk; # match the name of upstream directive which is defined above
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }

  location ~* ^/assets/ {
    # Per RFC2616 - 1 year maximum expiry
    expires 1y;
    add_header Cache-Control public;

    # Some browsers still send conditional-GET requests if there's a
    # Last-Modified header or an ETag header even if they haven't
    # reached the expiry date sent in the Expires header.
    add_header Last-Modified "";
    add_header ETag "";
    break;
  }
}
```


```
systemctl start nginx
puma -e production -d -b unix:///var/run/secretube_tk.sock
```


push TLS CA to `/root/.docker`

## HTTPS
```
https://gorails.com/guides/free-ssl-with-rails-and-nginx-using-let-s-encrypt
```