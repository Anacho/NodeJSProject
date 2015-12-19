db = require('./db') "#{__dirname}/../db/metrics"
module.exports =
  ###
  `get()`
  ------
  ###
  get: (id, callback) ->
    metric = {}
    rs = db.createReadStream
      gte: "metric:#{id}"
      lte: "metric:#{id}"
    rs.on 'data', (data) ->
      [_, _id] = data.key.split ':'
      [ _value, _timestamp] = data.value.split ':'
      metric =
        id: _id
        value: _value
        timestamp: _timestamp

    rs.on 'error', callback
    rs.on 'close', ->
      callback metric

  ###
  `save(id, metrics, cb)`
  ------------------------
  Save some metrics with a given id

  Parameters:
  `id`: An integer defining a batch of metrics
  `metrics`: An array of objects with a timestamp and a value
  `callback`: Callback function takes an error or null as parameter
  ###
  save: (id, metrics, callback) ->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    for m in metrics
      ws.write key: "metric:#{id}", value: "#{m.value}:#{m.timestamp}"
    ws.end()
