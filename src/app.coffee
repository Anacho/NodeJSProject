express = require 'express'
morgan = require 'morgan'
bodyparser = require 'body-parser'
session = require 'express-session'
levelStore = require('level-session-store')(session)

metrics = require './metrics'
users = require './users'

app = express()
router = express.Router()

express = require 'express'
morgan = require 'morgan'
bodyparser = require 'body-parser'
session = require 'express-session'
stylus = require 'stylus'
LevelStore = require('level-session-store')(session)
app = express()
compile = (str, path) ->
  stylus(str).set('filename', path).use nib()

metrics = require './metrics'
users = require './users'

# SETS
app.set 'port', 1889
app.set 'views', "#{__dirname}/../views"
app.set 'view engine', 'jade'

#USE
app.use morgan 'dev'
app.use bodyparser.json()
app.use bodyparser.urlencoded()
app.use stylus.middleware
  src: "#{__dirname}/../public"
  compile: this.compile
app.use '/', express.static "#{__dirname}/../public"


app.use session
  secret: 'anythingIsASecret'
  store: new LevelStore "#{__dirname}/../db/sessions"
  resave: true
  saveUninitialized: true

authCheck = (req, res, next) ->
  console.log "#{req.session.loggedIn}"
  unless req.session.loggedIn == true
    res.redirect '/login'
  else
    next()



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

app.get '/signup', (req, res) ->
  res.render 'signup', title: 'Sign Up'

app.get '/metric', (req, res) ->
  res.render 'addmetric'

app.get '/login', (req, res) ->
  res.render 'login', title: 'Log In'

app.get '/index/:id', (req, res) ->
  res.render 'index', title: 'NodeJSProject', username: "#{req.params.id}"

app.get '/logout', (req, res) ->
  delete req.session.connected
  delete req.session.username
  res.redirect '/login'

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
  users.get req.body.username, (err, data) ->
    if err then throw err
    unless req.body.password == data.password
      res.redirect '/login'
    else
      req.session.connected = true
      req.session.username = data.name
      res.redirect "/index/#{req.session.username}"

app.post '/signup', (req, res) ->
  users.save req.body.username, req.body.password, (err) ->
    if err then res.status(500).json err
    else
      console.log "save user #{req.body.username}"
      res.redirect '/login'

app.post '/login/:name.json', (req, res) ->
  users.login req.params.id, req.body, (err) ->
    if err then res.status(500).json err
    else res.status(200).send true

app.post '/metric', authCheck, (req, res) ->
  metric = []
  metric.push value: req.body.value, timestamp: new Date(req.body.date).getTime()
  metrics.save req.body.username, metric, (err) ->
    if err then res.status(500).json err
    else
      res.redirect "/index/#{req.session.username}"

app.listen app.get('port'), () ->
  console.log "listening on #{app.get 'port'}"
