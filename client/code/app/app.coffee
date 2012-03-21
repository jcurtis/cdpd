pad = require('/pad')
time = setTimeout '', 0

console.log "server ready"

savePad = ->
  console.log 'saving...'
  pad.save $.address.hash(), code.getValue(), ->
    console.log 'saved'

# Configure CodeMirror2 editor
options =
  lineNumbers: true
  mode: 'null'
  onChange: (instance, change) ->
    clearTimeout(time)
    time = setTimeout(savePad, 5000)
    pad.sendChange($.address.hash(), change)
code = CodeMirror(document.getElementById("editor"), options)

#loading
if $.address.hash().length > 0
  pad.load $.address.hash(), (obj) ->
    tmp = code.getOption('onChange')
    code.setOption 'onChange', () ->
      return
    code.setValue(obj.text)
    code.setOption('onChange', tmp)
    code.setOption('mode', obj.mode)
else
  pad.new (id, pad) ->
    tmp = code.getOption('onChange')
    code.setOption 'onChange', () ->
      return
    code.setValue(pad)
    code.setOption('onChange', tmp)
    $.address.hash(id)
 
ss.event.on 'pubChange', (info, channel) ->
  if sessionId() != info.session_id.split('/')[0]
    tmp = code.getOption('onChange')
    code.setOption 'onChange', () -> 
      #do nothing
      return
    renderChange code, info.change
    code.setOption('onChange', tmp)

# bootstrap stuff
$('.dropdown-toggle').dropdown()
$('.collapse').collapse()

# enable syntax highlight switching
$('.syntax').click ->
  mode = this.getAttribute 'mode'
  code.setOption 'mode', mode
  pad.setMode($.address.hash(), mode)
  console.log 'mode changed to ' + mode

ss.event.on 'pubMode', (mode, channel) ->
  code.setOption 'mode', mode
  $('#syntax-menu-title').text(mode)
  console.log 'mode changed remotely to ' + mode


# Private functions

sessionId = () ->
  id = document.cookie.valueOf "session_id" 
  val = id.split('=')[1].split('.')[0].split('%')[0]
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
