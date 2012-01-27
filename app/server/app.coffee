# Server-side Code

exports.actions =
  
  init: (cb) ->
    if @session.user_id
      R.get "user:#{@session.user_id}", (err, data) ->
        if data then cb data else cb false
    else
      cb false

  sendChange: (change, cb) ->
    if change?
      info = {
        change: change, 
        session_id: @session.id
      }
      SS.publish.broadcast 'newChange', info
      cb true
    else
      cb false

  create: (cb) ->
    # Generate a guid
    guid = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace /[xy]/g, (c) ->
      r = Math.random() * 16 | 0
      v = (if c is "x" then r else (r & 0x3 | 0x8))
      v.toString 16
    # Create database entry for guid
    R.set "pad:#{guid}", "New pad."
    # Subscribe user to this channel
    @session.channel.subscribe(guid)
    SS.publish.channel [guid], 'loadPad', {guid: guid, text: "New pad."}
    cb true


  load: (hash, cb) ->
    if hash.length > 1
      guid = hash.substring(1)
      text = R.get "pad:#{guid}", (err, data) ->
        SS.publish.channel [guid], 'loadPad', {guid: hash, text: data} if data
    else

  sendMessage: (message, cb) ->
    if message?
      SS.publish.channel [message.guid], 'newMessage', {user: 'user1', body: message.body}
      cb true
    else
      cb false

# Private functions

