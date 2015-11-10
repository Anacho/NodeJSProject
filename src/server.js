var http = require('http');
var users = require('./users.js');

http.createServer(function (req, res) {
	var path = req.url.split("/").splice(1, 2)
	
	if(path[0] == "get")
	{
		users.get(path[1], function (user) {
			var response = {
				info: "here's your user!",
				user: user
			}		
			res.writeHead(200, {content: 'application/json'});
			res.end(JSON.stringify(response));
		})
	}
	else if(path[0] == "save") {
		users.save(path[1], function(user) {
			var response = {
				info: "user saved!",
				user: user
			}
			res.writeHead(200, {content: 'application/json'});
			res.end(JSON.stringify(response));
		})
	}
	else {
		res.writeHead(404, {content: 'application/json'});
		res.end("Not a good path!");
	}
}).listen(2222, '127.0.0.1');