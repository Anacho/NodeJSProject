# Assignment:
http = require 'http'
users = require '../lib/users.js'
metrics = require '../lib/metrics.js'

http.createServer (req, res) ->
	path = req.url.split("/").splice 1, 2
	if path[0] is 'get'
		metric = users.login path[1], "merignac33"
		response =
			info: "here's your metric!"
			metric: metric
		res.writeHead 200, 'Content-Type': 'application/json'
		res.end JSON.stringify response
	else if path[0] is 'save'
		password = "merignac33"
		metric = [{value:1337, timestamp:Date.now()}]
		users.save path[1], password, (id) ->
			response =
				info: "metric saved!"
				id: id
			res.writeHead 200, 'Content-Type': 'application/json'
			res.end JSON.stringify response
	else
		res.writeHead 404, 'Content-Type': 'application/json'
		res.end "Not a good path!"
.listen(2222, '127.0.0.1')
