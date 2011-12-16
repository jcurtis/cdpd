# Client-side Code

# Bind to socket events
SS.socket.on 'disconnect', ->  
  $('#message').text('SocketStream server is down :-(')
SS.socket.on 'reconnect', ->   
  $('#message').text('SocketStream server is up :-)')

# This method is called automatically when the websocket 
# connection is established. Do not rename/delete
exports.init = ->
  
  # Setup CodeMirror
  options = 
    lineNumbers: true
    mode: "null"
    onChange: (instance, change) ->
      SS.server.app.sendChange change

  codeMirror = CodeMirror.fromTextArea(document.getElementById("code"), options)

  SS.events.on 'newChange', (info) ->
    if sessionId() != info.session_id
      tmp = codeMirror.getOption('onChange')
      codeMirror.setOption('onChange', () -> 
        #do nothing
        return
      )
      codeMirror.replaceRange info.change.text[0], 
        info.change.from, info.change.to
      codeMirror.setOption('onChange', tmp)


# Private methods
#
sessionId = () ->
  id = document.cookie.valueOf "session_id" 
  val = id.split('=')[1]
  return val
