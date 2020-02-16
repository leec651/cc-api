



log = (err) ->
  console.log err
  return 500

module.exports =
  data: require("./data")
  middleware: require("./middleware")
  log: log