faker = require 'faker/locale/en_US'

moment = require 'moment'
async = require 'async'
_ = require 'lodash'

{ IMAGES, ETHNICITY, ENROLLMENT_SOURCE, RELATIONSHIP } = require '../model/constant'
{ Contract, Person } = require '../model'

# remove policy holder from the constant
RELATIONSHIP = _.remove RELATIONSHIP, (item) -> item != 'POLICY_HOLDER'
POLICY_IDS = ["PB0", "PB1", "PB2", "PB3", "PB4", "PB5", "PB6", "PB7", "PB8", "PB9"]

dropDB = (cb) ->
  Db = require('mongodb').Db
  Server = require('mongodb').Server
  db = new Db('test', new Server('localhost', 27017));
  async.series [
    (eCb) -> db.dropCollection 'people', eCb
    (eCb) -> db.dropCollection 'contracts', eCb
  ], (err)->
    throw err if err
    console.log 'done'
    process.exit()

date = (num) ->
  year = Math.random() * 100 % num
  day  = Math.random() * 100 % 265
  return moment().subtract(year, 'year').subtract(day, 'day').toDate()

fakeAddress = ->
  return
    address1: faker.address.streetAddress()
    address2: faker.address.secondaryAddress()
    city: faker.address.city()
    state: faker.address.stateAbbr()
    zip: faker.address.zipCode()
    country: faker.address.country()

fakePerson = ->
  return
      firstName: faker.name.firstName()
      lastName: faker.name.lastName()
      phone: faker.phone.phoneNumber('###-###-####')
      email: faker.internet.email()
      dateOfBirth: date(100)
      sex: if _.random(0, 1) then 'FEMALE' else 'MALE'
      language: if _.random(0, 1) then 'ENG' else 'SPA'
      ethnicity: ETHNICITY[_.random(0, ETHNICITY.length-1)]
      image: IMAGES[_.random(0, IMAGES.length-1)]
      address: fakeAddress()

createPeople = (cb) ->
  data = require './data'
  console.log "Create #{data.people.length} people"
  async.eachLimit data.people, 2, (person, eCb) ->
    Person.countDocuments {email: person.email}, (err, count) ->
      return eCb err if err
      if count
        return eCb()
      person = Object.assign(person,
        phone: faker.phone.phoneNumber('###-###-####')
        image: IMAGES[_.random(0, IMAGES.length-1)]
      )
      person = new Person(person)
      person.save (err, saved) ->
        return eCb(err)
  , (err) ->
    return cb err if err
    return cb()

createFakePeople = (num, cb) ->
  console.log "creating #{num} fake ppl"
  async.timesLimit num, 10, (n, tCb) ->
    p = new Person fakePerson()
    p.save (err, db) ->
      return tCb()
  , (err) ->
    return cb err

createContracts = (number, cb) ->
  console.log "Creating #{number} contract(s)"
  async.times number, (n, tCb) ->
    Person.aggregate [ { $sample: { size: _.random(1, 5) } } ], (err, dbPeople) ->
      return tCb err if err
      insurees = []
      for {_id}, index in dbPeople
        if insurees.length
          insurees.push
            personId: _id
            relationship: RELATIONSHIP[_.random(0, RELATIONSHIP.length-1)]
        else
          insurees.push
            personId: _id
            relationship: 'POLICY_HOLDER'
      # create a contract
      contract = new Contract
        policyId: POLICY_IDS[_.random(0, POLICY_IDS.length-1)]
        source: ENROLLMENT_SOURCE[_.random(0, ENROLLMENT_SOURCE.length-1)]
        insurees: insurees
      return contract.save tCb
  , cb


NUMBER_PEOPLE   = 1000
NUMBER_CONTRACT = 100

async.series [
  # dropDB
  createPeople
  (sCb) -> createFakePeople(NUMBER_PEOPLE, sCb)
  (sCb) -> createContracts(NUMBER_CONTRACT, sCb)
], (err) ->
  throw err if err
  console.log "Done!"
  return process.exit()