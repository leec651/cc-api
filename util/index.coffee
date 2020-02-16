log = (err) ->
  console.log err
  return 500

module.exports =
  middleware: require("./middleware")
  log: log