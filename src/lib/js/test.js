var users = require('./users.js');
var should = require('should');

describe('get() function', function() {
  it('gets the user from a given ID', function(){
    var result = users.get(0, function(result){
      result.id.should.equal(0);
    })
  })
})

describe('save() function', function() {
  it('saves an user given its name', function() {
    var result = users.save('debesson-le', function(result) {
      result.name.should.equal('debesson-le');
    })
  })
})
