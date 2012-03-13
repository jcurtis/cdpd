db = require('redis').createClient()

exports.actions = (req, res, ss) ->

  req.use('session')

  load: (id) ->
    if valid(id)
      req.session.channel.subscribe(id)
      db.hgetall "pad:#{id}", (err, obj) ->
        if err
          res('error loading pad from database')
        else
          res(obj)
    else
      res("empty")

  sendChange: (id, change) ->
    if valid(id)
      # broadcast change to all subscribed
      info = {
        change: change,
        session_id: req.session.id
      }
      ss.publish.channel id, 'pubChange', info, (cb) ->
        res(cb)
    else
      res(false)

  new: () ->
    newId = uuid()
    defaultText = "default text"
    req.session.channel.subscribe(newId)
    db.hset "pad:#{newId}", 'text', defaultText 
    db.hset "pad:#{newId}", 'mode', 'text/plain-text' 
    res(newId, defaultText)

  save: (id, text) ->
    db.hset "pad:#{id}", 'text', text
    res(true)

  setMode: (id, mode) ->
    db.hset "pad:#{id}", 'mode', mode
    ss.publish.channel id, 'pubMode', mode, (cb) ->
      res(cb)

valid = (id) ->
  id && id.length == "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".length

uuid = () ->
  id = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace /[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = (if c is "x" then r else (r & 0x3 | 0x8))
    v.toString 16
  id
