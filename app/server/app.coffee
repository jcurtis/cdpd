# Server-side Code

exports.actions =
  
  init: (cb) ->
    cb "SocketStream version #{SS.version} is up and running. 
      This message was sent over Socket.IO so everything is working OK."

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

  sendMessage: (message, cb) ->
    if message?
      SS.publish.broadcast 'newMessage', {user: 'user1', body: message}
      cb true
    else
      cb false
