mongoose = require 'mongoose'

mongo =
  server: 'mongodb://localhost:27017/test'
  options:
    useUnifiedTopology: true
    useCreateIndex: true
    useNewUrlParser: true

mongoose.Promise = global.Promise

# Connect to mongoDB
mongoose.connect mongo.server, mongo.options
mongoose.connection.on 'error', (err) ->
  console.error mongo
  throw new Error(err) if err

mongoose.connection.once 'open', () ->
  console.log "Connected to #{mongo.server}"

# Exports all db access objects
modelCache = {}
model = (name) ->
  Object.defineProperty module.exports, name,
    get: () ->
      modelCache[name] ?= mongoose.model(name, require("./#{name}"))
      return modelCache[name]

model(dao) for dao in ['Person', 'Contract']

# objectId function
module.exports.generateObjectId = mongoose.Types.ObjectId