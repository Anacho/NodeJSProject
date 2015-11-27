module.exports =
  save: (name, callback) ->
    user =
      id: "2222"
      name: name
    callback user

  get: (id, callback) ->
    user =
      name: "debesson"
      id: id
    callback user
