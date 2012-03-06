
exports.load = (id, cb) ->
    if valid(id)
      ss.rpc('pad.load', id, cb)
    else
      cb(false)

exports.sendChange = (id, change, cb) ->
  ss.rpc('pad.sendChange', id, change, cb)

exports.new = (cb) ->
  ss.rpc('pad.new', cb)

exports.save = (id, text, cb) ->
  ss.rpc 'pad.save', id, text, cb

# private
valid = (id) ->
  id && id.length == "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".length

