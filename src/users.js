module.exports = {
	save: function(name, callback) {
		// save the user
		var user = {
			id: "2222",
			name: name
		}
		callback(user);
	},
	
	get: function(id, callback) {
		// get a user
		var user = {
			name: "debesson",
			id: id
		}
		callback(id);
	}
}