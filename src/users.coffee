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
    rs.on 'error', -> callback "Error : get users"
    rs.on 'close', -> callback user

  login: (name, password) ->
    user = {}
<<<<<<< HEAD
    this.get(name, (user) ->
      if(password == user.password)
        return true
      false
    )
=======
    user = this.get name, callback
    console.log "#{user.password}"
    if password == user.password
      console.log "Login success"
      true
    console.log "T'es nul"
    false


###
if(password == user.password)
  console.log "true"
  return true
console.log "false"
false
###
>>>>>>> 3d5742b052f528257cc0895530ea91e7c2748846
