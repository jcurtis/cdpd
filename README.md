# Prototype for c(o)d(e)p(a)d project.

### Requirements
* [node.js](http://nodejs.org/)
* [socketstream](https://github.com/socketstream/socketstream)
    git clone https://github.com/socketstream/socketstream.git
    cd socketstream
    sudo npm link
* [redis](http://redis.io/)

### Install dependencies (requires npm 1.*)
In cdpd directory:
    npm install
    npm link socketstream

### Run server
Run redis server
    redis-server

Start node server
    node app.js
