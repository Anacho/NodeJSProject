# Assignment:
http = require 'http'
users = require '../lib/users.js'
metrics = require '../lib/metrics.js'

http.createServer (req, res) ->
	path = req.url.split("/").splice 1, 2
	if path[0] is 'get'
		metrics.get path[1], (user) ->
			response =
				info: "here's your user!"
				user: user
			res.writeHead 200, 'Content-Type': 'application/json'
			res.end JSON.stringify response
	else if path[0] is 'save'
		metric = [{value:1337, timestamp:new Date('2015-12-01 10:35 UTC').getTime()}]
		metrics.save path[1], metric, (metric) ->
			response =
				info: "metric saved!"
				metric: metric
			res.writeHead 200, 'Content-Type': 'application/json'
			res.end JSON.stringify response
	else
		res.writeHead 404, 'Content-Type': 'application/json'
		res.end "Not a good path!"
.listen(2222, '127.0.0.1')
