db = require('./db') "#{__dirname}/../db/metrics"
module.exports =
  ###
  `get()`
  ------
  ###
  get: (id, callback) ->
    metric = {}
    rs = db.createReadStream
      lte: "value:#{id}"
      gte: "value:#{id}"
    rs.on 'data', (data) ->
      [_, _id] = data.key.split ':'
      [_timestamp, _value] = data.value.split ':'
      metric =
        id: _id
        timestamp: _timestamp
        value: _value

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
      {timestamp, value} = m
      ws.write key: "metric:#{id}:#{id}", timestamp: timestamp, value: value
    ws.end()
