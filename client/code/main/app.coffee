


# wait for connection
SocketStream.event.on 'ready', ->
  console.log "server ready"

  # Configure CodeMirror2 editor
  options =
    lineNumbers: true
    mode: 'null'
    #onChange: (instance, change) ->
  code = CodeMirror(document.getElementById("editor"), options)

