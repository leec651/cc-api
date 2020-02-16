_ = require 'lodash'
async = require 'async'

{Contract, Person} = require '../model'
data = require './data'
{ENROLLMENT_SOURCE, RELATIONSHIP} = require '../model/constant'

# remove policy holder from the constant
RELATIONSHIP = _.remove RELATIONSHIP, (item) -> item != 'POLICY_HOLDER'

createPeople = (cb) ->
  totalSaved = 0
  async.eachLimit data.people, 2, (person, eCb) ->
    Person.countDocuments {email: person.email}, (err, count) ->
      return eCb err if err
      if count
        console.log "#{person.email} existed. continue.."
        return eCb()
      person = new Person(person)
      person.save (err, saved) ->
        totalSaved++
        return eCb(err)
  , (err) ->
    return cb err if err
    console.log "Saved #{totalSaved} person"
    return cb()

randomPeople = (people, number) ->
  people = _.cloneDeep people
  result = []
  for i in [0...number]
    index = _.random(0, _.size(people)-1)
    result.push people.splice(index, 1)[0]
  return result

createContracts = (cb) ->
  number = 20
  console.log "Created #{number} contract(s)"
  Person.find {}, (err, dbPeople) ->
    async.times number, (n, tCb) ->
      return tCb err if err
      # create some test insurees
      people = randomPeople(dbPeople, _.random(1, 4))
      insurees = []
      for {_id}, index in people
        if index == 0
          insurees.push
            personId: _id
            relationship: 'POLICY_HOLDER'
        else
          insurees.push
            personId: _id
            relationship: RELATIONSHIP[_.random(0, RELATIONSHIP.length-1)]
      # create a contract
      contract = new Contract
        policyId: data.policyIds[_.random(0, data.policyIds.length-1)]
        source: ENROLLMENT_SOURCE[_.random(0, ENROLLMENT_SOURCE.length-1)]
        insurees: insurees
      return contract.save tCb
    , cb


async.series [
  createPeople
  createContracts
], (err) ->
  throw err if err
  console.log "Done!"
  return process.exit()