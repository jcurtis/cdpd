db = require('redis').createClient()

exports.actions = (req, res, ss) ->

  req.use('session')

  load: (id) ->
    if valid(id)
      db.get "pad:#{id}", (err, data) ->
        if err
          res('error loading pad from database')
        else
          res(data)
      req.session.channel.subscribe(id)
    else
      res("empty")

  sendChange: (id, change) ->
    if valid(id)
      # broadcast change to all subscribed
      info = {
        change: change,
        session_id: req.session.id
      }
      ss.publish.channel(id, 'pubChange', info)
      res(true)
    else
      res(false)

  new: () ->
    newId = uuid()
    defaultText = "default text"
    db.set "pad:#{newId}", defaultText 
    res(newId, defaultText)

valid = (id) ->
  id && id.length == "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".length

uuid = () ->
  id = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace /[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = (if c is "x" then r else (r & 0x3 | 0x8))
    v.toString 16
  id
