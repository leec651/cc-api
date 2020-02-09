{Person} = require './model'
request = require 'request'


insurees = [{
  personId: '5e37c275ba215f84fc90f0eb'
  relationship: 'POLICY_HOLDER'
}, {
  personId: '5e37c291ead31685ff87a396'
  relationship: 'CHILD'
}, {
  personId: '5e37c28467e743859dd17923'
  relationship: 'CHILD'
}]

contract =
  policyId: 'POLICYID_1'
  source: 'CALCHOICE'
  insurees: insurees

# request.post 'http://localhost:3000/contract',
#   json: true
#   body: contract
# , (err, res, body) ->
#   throw err if err
#   console.log res.statusCode
#   console.log JSON.stringify(res.body, null, 2)


request.post 'http://localhost:3000/contract/5e3a02ff73f4230e7e597b9d/add',
  json: true
  body:
    insurees: [{
      personId: '5e3a03e9507fae1640dc1927'
      relationship: 'SPOUSE'
    }]
, (err, res, body) ->
  throw err if err
  console.log res.statusCode
  console.log JSON.stringify(res.body, null, 2)

# request.post 'http://localhost:3000/contract/5e37cb468b4ba44c27772877/remove/5e37c28467e743859dd17923',
#   json: true
# , (err, res, body) ->
#   throw err if err
#   console.log res.statusCode
#   console.log JSON.stringify(res.body, null, 2)

# request.get 'http://localhost:3000/contract/person/5e37c275ba215f84fc90f0eb',
#   json: true
# , (err, res) ->
#   throw err if err
#   console.log res.statusCode
#   console.log JSON.stringify(res.body, null, 2)