{validate, format} = require '../util/middleware'
{Person} = require '../model'

module.exports = (app) ->

  app.get '/person/:id', (req, res) ->
    {id} = req.params
    Person.findById id, (err, dbPerson) ->
      return res.sendStatus 500
      return res.json dbPerson

  app.post '/person', validate({
    firstName:  { required: true, type: String }
    lastName:   { required: true, type: String }
    ssn:        { required: true, type: String, format: format.ssn   }
    email:      { required: true, type: String, format: format.email }
  }), (req, res, next) ->
    person = new Person req.body
    person.save (err, dbPerson) ->
      if err
        if err.code == 11000
          return res.sendStatus 409
        else
          return res.sendStatus 500
      return res.json dbPerson.toHypermediaObject()