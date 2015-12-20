express = require 'express'
metrics = require './metrics'
users = require './users'
morgan = require 'morgan'
bodyparser = require 'body-parser'
session = require 'express-session'
levelStore = require('level-session-store')(session)

app = express()
router = express.Router()

middleware = (req, res, next) ->
  console.log "#{req.method} on #{req.url}"
  next()

# SETS
app.set 'port', 1889
app.set 'views', "#{__dirname}/../views"
app.set 'view engine', 'jade'

#USE
app.use require('body-parser')()
app.use middleware
app.use morgan 'dev'
app.use '/', express.static "#{__dirname}/../public"
###
app.use session
  secret: 'MyAppSecret'
  store: new LevelStore './db/sessions'
  resave: true
  saveUnitialized: true
###

#GET
app.get '/', (req, res) ->
  res.render 'index',
    title: 'Node JS Project',
###
app.get '/myroute', (req, res) ->
  #route logic
app.use router
###
app.get '/hello/:name', (req, res) ->
  res.status(200).send "Hello #{req.params.name}"

app.get '/signup', (req, res) ->
  res.render 'signup'

app.get '/login', (req, res) ->
  res.render 'login'

app.get '/layout', (req, res) ->
  res.render 'layout'

app.get '/metrics.json', (req, res) ->
  res.status(200).send metrics.get((err) ->
    if err then res.status(500).json err
    else res.status(200).send "User saved")

app.get '/metrics.json/:id', (req, res) ->
  metrics.get req.params.id, (metric) ->
    response =
      metric: metric
    res.writeHead 200, 'Content-Type': 'application/json'
    res.end JSON.stringify response

app.get '/delete/:username', (req, res) ->
  res.status(200).send users.remove(req.params.username, (err) ->
    if err
      return console.log('Ooops!', err)
    console.log 'Great success dear leader!'
    return)

app.post '/user/:name.json', (req, res) ->
  users.save req.params.id, req.body, (err) ->
    if err then res.status(500).json err
    else res.status(200).send "User saved"

app.post '/login', (req, res) ->
  users.login req.body.username, req.body.password, (err) ->
    if err then res.status(500).json err
    else
      console.log "Log in success of #{req.body.username}"
      res.redirect '/layout'

app.post '/signup', (req, res) ->
  users.save req.body.username, req.body.password, (err) ->
    if err then res.status(500).json err
    else
      console.log "save user #{req.body.username}"
      res.redirect '/login'

app.post '/login/:name.json', (req, res) ->
  users.login req.params.id, req.body, (err) ->
    if err then res.statuts(500).json err
    else res.status(200).send true

app.post '/metric/:id.json', (req, res) ->
  metrics.save req.params.id, req.body, (err) ->
    if err then res.status(500).json err
    else res.status(200).send "Metrics saved"

app.listen app.get('port'), () ->
  console.log "listening on #{app.get 'port'}"
