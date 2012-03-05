tools = require('tools')
pad = require('pad')

# wait for connection
SocketStream.event.on 'ready', ->
  console.log "server ready"

  # Configure CodeMirror2 editor
  options =
    lineNumbers: true
    mode: 'null'
    onChange: (instance, change) ->
      pad.sendChange($.address.hash(), change)
  code = CodeMirror(document.getElementById("editor"), options)

  #loading
  if $.address.hash().length > 0
    pad.load $.address.hash(), (pad) ->
      code.setValue(pad)
   
  ss.event.on 'pubChange', (info) ->
    if sessionId() != info.session_id
      tmp = code.getOption('onChange')
      code.setOption 'onChange', () -> 
        #do nothing
        return
      renderChange code, info.change
      code.setOption('onChange', tmp)

# Private functions

sessionId = () ->
  id = document.cookie.valueOf "session_id" 
  val = id.split('=')[1]
  return val.split('.')[0]

renderChange = (instance, change) ->
  #format the changes
  insert = change.text[0]
  for line in change.text[1..]
    insert += '\n' + line 

  #insert them
  instance.replaceRange insert, change.from, change.to
  if change.next?
    renderChange instance, change.next

