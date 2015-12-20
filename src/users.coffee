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
    user = {}
    rs = db.createReadStream
      gte: "user:#{name}"
      lte: "user:#{name}"
    rs.on 'data', (data) ->
      user =
        name: name
        password: data.value
    rs.on 'error', -> callback "Error"
    rs.on 'close', -> callback user

  login: (name, password, callback) ->
    user = {}
    this.get(name, (user) ->
      if(password == user.password)
        console.log "true"
        return true
      console.log "false"
      false
    )
