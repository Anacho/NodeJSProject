express = require 'express'
metrics = require './metrics'
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

app.get '/metrics.json', (req, res) ->
  res.status(200).json metrics.get()

app.get '/hello/:name', (req, res) ->
  res.status(200).send req.params.name

app.post '/metric/:id.json', (req, res) ->
  metrics.save req.params.id, req.body, (err) ->
    if err then res.status(500).json err
    else res.status(200).send "Metrics saved"

app.listen app.get('port'), () ->
  console.log "listening on #{app.get 'port'}"
