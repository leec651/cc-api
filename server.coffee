path = require 'path'
express = require 'express'
bodyParser = require 'body-parser'
cors = require 'cors'

app = express()


app.set('service', 'person')
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended: true}))
app.use cors()

# Set up routes
require('./routes')(app)

app.use (err, req, res, next) ->
  console.error(err.stack)
  return res.sendStatus(500)

server = app.listen 3000, () ->
  console.log "Listening on port #{3000}"

server.setTimeout 3600000