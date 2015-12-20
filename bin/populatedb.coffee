#!/usr/bin/env coffee

exec = require('child_process').exec
###
exec "rm -rf #{__dirname}/../db/metrics && mkdir #{__dirname}/../db/metrics", (err, stdout, stderr) ->
  if err then throw err
###
  # Require after rm and mkdir or DB is deleted once in callback
metrics = require '../src/metrics'
users = require '../src/users'

console.log 'DB deleted'
console.log 'Creating metrics'
met = [
  [
    timestamp: new Date('2015-12-01 10:30 UTC').getTime(),
    value: 26
  ,
    timestamp: new Date('2015-12-01 10:35 UTC').getTime(),
    value: 23
  ,
    timestamp: new Date('2015-12-01 10:40 UTC').getTime(),
    value: 20
  ,
    timestamp: new Date('2015-12-01 10:45 UTC').getTime(),
    value: 19
  ,
    timestamp: new Date('2015-12-01 10:50 UTC').getTime(),
    value: 18
  ,
    timestamp: new Date('2015-12-01 10:55 UTC').getTime(),
    value: 20
  ],
    [
      timestamp: new Date('2015-11-01 10:30 UTC').getTime(),
      value: 26
    ,
      timestamp: new Date('2015-11-01 10:35 UTC').getTime(),
      value: 23
    ,
      timestamp: new Date('2015-11-01 10:40 UTC').getTime(),
      value: 20
    ,
      timestamp: new Date('2015-11-01 10:45 UTC').getTime(),
      value: 19
    ,
      timestamp: new Date('2015-11-01 10:50 UTC').getTime(),
      value: 18
    ,
      timestamp: new Date('2015-11-01 10:55 UTC').getTime(),
      value: 20
    ]
]

console.log "Creating user \'admin\' with password \'password\'..."
user =
  username: "admin"
  password: "aaa"

console.log "Saving user"
users.save user.username, user.password, (err) ->
  return next err if err

for metric in met
  console.log "Saving..."
  metrics.save "admin", metric, (err) ->
    return next err if err
