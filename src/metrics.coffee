#db = require('./db') "C:\\Users\\ThienAn\\Documents\\GitHub\\NodeJSProject\\db\\metrics"
db = require('./db') "#{__dirname}/../db/metrics"

module.exports =
  ###
  `get()`
  ------
  Returns some hard coded metrics
  ###
  get: (callback) ->
    metrics = {}
    rs = db.createReadStream
      gte: "metrics"
    rs.on 'error', callback
    rs.on 'data', (data) ->
      metrics = data.value
    return metrics

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
      ws.write key: "metric:#{id}:#{timestamp}", value: value
    ws.end()

    ###
    'remove(id)'
    Remove the metric with the given id

    ###
    remove: (id) ->
