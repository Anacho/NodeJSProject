db = require('./db') "#{__dirname}/../db/user"

module.exports =
  save: (name, password, callback) ->
    user = {}
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    ws.write key: "user:#{name}", value: "#{password}"
    ws.end()

  get: (name, callback) ->
    rs = db.createReadStream
      gte: "metric:#{name}"
      lte: "metric:#{name}"
    rs.on 'data', (data) ->
      data.value
    rs.on 'error', -> callback "Error"
    rs.on 'close', -> callback "Error"

  login: (name, password, callback) ->
    if(password == this.get(name))
      true
    false
