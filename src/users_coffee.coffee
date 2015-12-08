db = require('./db') "#{__dirname}/../db/user"

module.exports =
  save: (name, callback) ->
    user = {}
    rs = db.createReadStream
      
    callback user

  get: (id, callback) ->
    user =
      name: "debesson"
      id: id
    callback user
