# Prototype for c(o)d(e)p(a)d project.

### Requirements

[node.js](http://nodejs.org/) -- I'm using 0.6.11

[socketstream](https://github.com/socketstream/socketstream)

Note: SocketStream is now installed through NPM. No need to install it yourself.

[redis](http://redis.io/)

### Install project (requires npm 1.x)

    git clone https://github.com/jcurtis/cdpd.git
    cd cdpd
    sudo npm install

### Run server

Run redis server

    redis-server redis.conf

Start node server

    node app.js
