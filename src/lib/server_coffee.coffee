# Assignment:

http = require 'http'
users = require './users.js'

http.createServer (req, res) ->
	path = req.url.split("/").splice 1, 2
	if path[0] is 'get'
		users.get path[1], (user) ->
			response =
				info: "here's your user!"
				user: user
			res.writeHead 200, 'Content-Type': 'application/json'
			res.end JSON.stringify response
	else if path[0] is 'save'
		users.save path[1], (user) ->
			response =
				info: "user saved!"
				user: user
			res.writeHead 200, 'Content-Type': 'application/json'
			res.end JSON.stringify response
	else
		res.writeHead 404, 'Content-Type': 'application/json'
		res.end "Not a good path!"
.listen(2222, '127.0.0.1')
