users = require './users.js'
should = require 'should'

describe 'get() function', ->
  it 'gets the user from a given ID', ->
    result = users.get 0, (result) ->
      result.id.should.equal 0

describe 'save() function', ->
  it 'saves an user given its name', ->
    result = users.save 'debesson-le', (result) ->
      result.name.should.equal 'debesson-le'
