
exports.actions = (req, res, ss) ->

  req.use('session')

  load: (id) ->
    if id && id.length == "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".length
      #todo: fetch pad
      pad = "remember to implement redis"
      req.session.channel.subscribe(id)
      #ss.publish.channel(id, 'loadPad', pad)
      res(pad)
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
      
valid = (id) ->
  if id && id.length == "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".length
    true
  else
    false

