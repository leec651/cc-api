path        = require 'path'
fs          = require 'fs'
_           = require 'lodash'
fs          = require 'fs'
multer      = require 'multer'
formidable  = require 'formidable'
parse       = require 'csv-parse'

upload  = multer({ dest: 'uploads/' })

module.exports = (app) ->

  app.get '', (req, res) ->
    console.log 'yolo i just got a request'
    message = { message: 'hello emma. its a get request' }
    return res.status(200).send(message)

  app.post '/multer', upload.single('exemptions'), (req, res) ->
    filepath = path.resolve(__dirname, '..' , req.file.path)
    file = fs.readFileSync(filepath, 'utf8')
    parse file,
      columns: true
      skip_empty_lines: true
    , (err, output) ->
      res.sendStatus 500 if err
      console.log output
      return res.sendStatus(200)

  app.post '/formidable', (req, res) ->
    form = formidable({ multiples: true })
    form.parse req, (err, fields, files) ->
      return next(err) if err
      console.log 'fields', fields
      console.log 'files', files
      console.log 'done'
      return res.sendStatus(200)

  app.get '/home', (req, res) ->
    res.set 'Content-Type', 'text/html'
    res.send(new Buffer('<html><body>hi emma</body></html>'))


  require("./person")(app)
  require("./contract")(app)
