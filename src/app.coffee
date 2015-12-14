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
  res.render 'login',
    title: 'Node JS Project',
###
app.get '/myroute', (req, res) ->
  #route logic
app.use router
###
app.get '/hello/:name', (req, res) ->
  res.status(200).send "Hello #{req.params.name}"

app.get '/metrics.json', (req, res) ->
  res.status(200).send metrics.get((err) ->
    if err then res.status(500).json err
    else res.status(200).send "User saved")

app.get '/login', (req, res) ->
  username = "toto"
  user =  users.get(username, (err) ->
       if err then res.status(500).json err)
  res.status(200).send user

app.get '/signin', (req, res) ->
  username = "toto"
  password = "test"
  name = "Toto"
  email = "test@test.fr"
  users.save username, password, name, email, (err) ->
    if err then res.status(500).json err
    else res.status(200).send "User saved"

app.get '/delete/:username', (req, res) ->
  res.status(200).send users.remove(req.params.username, (err) ->
    if err
      return console.log('Ooops!', err)
    console.log 'Great success dear leader!'
    return)

app.post '/metric/:id.json', (req, res) ->
  metrics.save req.params.id, req.body, (err) ->
    if err then res.status(500).json err
    else res.status(200).send "Metrics saved"

app.listen app.get('port'), () ->
  console.log "listening on #{app.get 'port'}"
