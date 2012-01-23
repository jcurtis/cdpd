# Prototype for c(o)d(e)p(a)d project.
http://cdpd.no.de

### Requirements
* [node.js](http://nodejs.org/)
* [socketstream](https://github.com/socketstream/socketstream)
* [redis](http://redis.io/)
* optional
  * [foreman](http://ddollar.github.com/foreman/)

### Install dependencies (requires npm 1.*)
    npm install

### Run server
    redis-server
    node_modules/socketstream/bin/socketstream start

    //if you have foreman installed:
    foreman start
