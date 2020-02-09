_ = require 'lodash'
fs = require 'fs'

module.exports = (app) ->
  require("./person")(app)
  require("./contract")(app)
