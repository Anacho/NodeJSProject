express = require 'express'
metrics = require './metrics'
users = require './users'
morgan = require 'morgan'
bodyparser = require 'body-parser'
session = require 'express-session'
levelStore = require('level-session-store')(session)

app = express()

myMiddleware = (req, res, next) ->
  console.log "#{req.method} on #{req.url}"
  next()


app.set 'port', 1889
app.set 'views', "#{__dirname}/../views"
app.set 'view engine', 'jade'

app.use '/', express.static "#{__dirname}/../public"
app.use require('body-parser')()
app.use myMiddleware
app.use morgan 'dev'

app.get '/', (req, res) ->
  res.render 'index',
    locals:
      title: 'My ECE test page'
  res.status(200).send "Welcome to the api"

app.get '/hello/:name', (req, res) ->
  res.status(200).send "Hello #{req.params.name}"

app.get '/metrics.json/:id', (req, res) ->
  metrics.get req.params.id, (metric) ->
    response =
      metric: metric
    res.writeHead 200, 'Content-Type': 'application/json'
    res.end JSON.stringify response

app.get '/hello/:name', (req, res) ->
  res.status(200).send req.params.name

app.post '/user/:name.json', (req, res) ->
  users.save req.params.id, req.body, (err) ->
    if err then res.status(500).json err
    else res.status(200).send "User saved"

app.post '/login/:name.json', (req, res) ->
  users.login req.params.id, req.body, (err) ->
    if err then res.statuts(500).json err
    else res.statuts(200).send true

app.post '/metric/:id.json', (req, res) ->
  metrics.save req.params.id, req.body, (err) ->
    if err then res.status(500).json err
    else res.status(200).send "Metrics saved"

app.listen app.get('port'), () ->
  console.log "listening on #{app.get 'port'}"
