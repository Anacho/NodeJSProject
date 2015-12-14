#db = require('./db') "C:\\Users\\ThienAn\\Documents\\GitHub\\NodeJSProject\\db\\users"
db = require('./db') "#{__dirname}/../db/user"

module.exports =
  get: (username, callback) ->
    user = {}
    rs = db.createReadStream
      gte: "users: #{username}"
      lte: "users: #{username}"
    rs.on 'data', (data) ->
      [_, _username] = data.key.split ':'
      [_name, _password, _email] = data.value.split ':'
      user =
        username: _username,
        name: _name,
        password: _password,
        email: _email
    rs.on 'error', callback
    rs.on 'close', ->
      callback null, user

  save: (username, password, name, email, callback) ->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    ws.write key: "username:#{username}", value: "name: #{name}, password: #{password}, email : #{email}"
    ws.end()

  remove: (username, callback) ->
    db.batch username, callback
