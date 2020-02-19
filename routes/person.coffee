_ = require 'lodash'

{validate, format} = require '../util/middleware'
{log} = require '../util'
{Person} = require '../model'


module.exports = (app) ->

  app.get '/people/random', (req, res) ->
    Person.aggregate [ { $sample: { size: 3 } } ], (err, dbPeople) ->
      return res.sendStatus log(err) if err
      return res.sendStatus 404 if not dbPeople
      return res.json dbPeople.map((person) -> new Person(person).toJson())

  app.get '/person/search', (req, res) ->
    { text } = req.query
    console.log 'search for', text
    Person.find { $text: { $search: text } }, (err, dbPeople) ->
      return res.sendStatus log(err) if err
      dbPeople = dbPeople.map (person) -> person.toJson()
      return res.json dbPeople

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
          return res.sendStatus log(err)
      return res.json dbPerson.toHypermediaObject()

  app.get '/person/:id', (req, res) ->
    {id} = req.params
    Person.findById id, (err, dbPerson) ->
      return res.sendStatus log(err) if err
      return res.sendStatus 404 if not dbPerson
      return res.json dbPerson.toJson()

  app.put '/person/:id', (req, res) ->
    Person.findById req.params.id, (err, dbPerson) ->
      return res.sendStatus log(err) if err
      return res.sendStatus 404 if not dbPerson
      fields = _.pick req.body, [
        'sex'
        'ethnicity'
        'language'
        'firstName'
        'lastName'
        'dateOfBirth'
        'phone'
      ]
      Object.assign dbPerson, fields
      dbPerson.save (err, dbPerson) ->
        return res.sendStatus log(err) if err
        return res.json dbPerson.toJson()