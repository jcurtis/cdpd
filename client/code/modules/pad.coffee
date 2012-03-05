
exports.load = (id, cb) ->
    if valid(id)
      ss.rpc('pad.load', id, cb)
    else
      cb(false)

exports.sendChange = (id, change, cb) ->
  ss.rpc('pad.sendChange', id, change, cb)

# private
valid = (id) ->
  id && id.length == "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".length

