_ = require 'lodash'
fs = require 'fs'

module.exports = (app) ->

  app.get '', (req, res) ->
    console.log 'yolo i just got a request'
    message = { message: 'hello emma. its a get request' }
    return res.status(200).send(message)

  app.post '', (req, res) ->
    message = { message: 'post', body: req.body }
    return res.status(200).send(message)

  app.get '/home', (req, res) ->
    res.set 'Content-Type', 'text/html'
    res.send(new Buffer('<html><body>hi emma</body></html>'))


  require("./person")(app)
  require("./contract")(app)
