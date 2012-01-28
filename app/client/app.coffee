# Client-side Code

# Bind to socket events
SS.socket.on 'disconnect', ->  
  $('#message').text('SocketStream server is down :-(')
SS.socket.on 'reconnect', ->   
  $('#message').text('SocketStream server is up :-)')

# This method is called automatically when the websocket 
# connection is established. Do not rename/delete
exports.init = ->

  SS.server.app.init (user) ->
    if user then console.log('user logged in: ' + user)

  # Set up new pad
  if location.hash == ""
    SS.server.app.create (pad) ->
      if pad then console.log('new pad created')
  # or load one
  else
    SS.server.app.load location.hash, (pad) ->
      if pad then console.log('pad loaded')

  SS.events.on 'loadPad', (pad) ->
    codeMirror.setValue(pad.text)
    location.hash = pad.guid

  
  # Editor
  options = 
    lineNumbers: true
    mode: "null"
    onChange: (instance, change) ->
      SS.server.app.sendChange change

  codeMirror = CodeMirror.fromTextArea(document.getElementById("code"), options)

  # Editor features
  $('#undo').click ->
    codeMirror.undo()
  $('#redo').click ->
    codeMirror.redo()
  $('#highlight').change ->
    mode = $('#highlight option:selected').val()
    codeMirror.setOption 'mode', mode

  # Editor sync
  SS.events.on 'newChange', (info) ->
    if sessionId() != info.session_id
      tmp = codeMirror.getOption('onChange')
      codeMirror.setOption('onChange', () -> 
        #do nothing
        return
      )
      renderChange codeMirror, info.change
      codeMirror.setOption('onChange', tmp)

  #Chat
  $('form#sendMessage').submit ->
    newMessage = $('#newMessage').val()
    SS.server.app.sendMessage newMessage, (response) ->
      if response.error then alert(response.error) else $('#newMessage').val('')
    false

  SS.events.on 'newMessage', (message) ->
    $('#templates-message').tmpl(message).appendTo('#messages')

# Private functions

sessionId = () ->
  id = document.cookie.valueOf "session_id" 
  val = id.split('=')[1]
  return val

renderChange = (instance, change) ->
  #format the changes
  insert = change.text[0]
  for line in change.text[1..]
    insert += '\n' + line 
  
  #insert them
  instance.replaceRange insert, change.from, change.to
  if change.next?
    renderChange instance, change.next

