_ = require 'lodash'
async = require 'async'

{validate, format} = require '../util/middleware'
{Contract, Eligibility} = require '../model'

module.exports = (app) ->

  app.get '/contract/:id', (req, res) ->
    Contract.findById req.params.id, (err, dbContract) ->
      return res.sendStatus 500 if err
      return res.json dbContract.toJson()

  app.get '/contract/person/:personId', (req, res) ->
    Contract.find {'insurees.personId': req.params.personId}, (err, contracts) ->
      return res.sendStatus 500 if err
      return res.json(_.map contracts, (contract) -> contract.toJson())

  app.post '/contract', validate({
    policyId: { type: String, required: true }
    source:   { type: String, required: true }
    insurees: { type: Array,  required: true }
  }), (req, res) ->
    {policyId, source, insurees} = req.body

    # validation
    phCount = 0
    errors = []
    peopleCount = {}
    for insuree in insurees
      phCount++ if insuree.relationship == 'POLICY_HOLDER'
      peopleCount[insuree.personId] = if peopleCount[insuree.personId] then peopleCount[insuree.personId] + 1 else 1
      delete insuree.effecuatedAt
      delete insuree.cancelledAt
      delete insuree.terminatedAt

    if phCount != 1
      errors.push
        field: 'insurees'
        message: "One contract can only contain one policy holder. Received #{phCount}."
    for personId, count of peopleCount when count > 1
      errors.push
        field: 'insurees'
        message: "One person one occurrence per contract. Found #{count} for person #{personId}."

    if not _.isEmpty errors
      return res.status(400).send(errors)

    # save
    contract = new Contract req.body
    contract.save (err, dbContract) ->
      console.log 'err', err
      return res.sendStatus 409 if err and err.code == 11000
      return res.sendStatus 500 if err
      return res.sendStatus 404 if not dbContract
      return res.json dbContract.toJson()


  app.post '/contract/:contractId/add', validate({
    insurees: { type: Array,  required: true }
  }), (req, res) ->
    Contract.findById req.params.contractId, (err, dbContract) ->
      return res.sendStatus(500) if err
      return res.sendStatus(404) if not dbContract
      # probably should move this to save
      keyedInsurees = _.keyBy dbContract.insurees, (insuree) -> insuree.personId
      errors = []
      for insuree in req.body.insurees
        if keyedInsurees[insuree.personId]
          errors.push
            field: 'insurees'
            message: "One person one occurrence per contract. Person #{insuree.personId} already existed."
        if insuree.relationship == 'POLICY_HOLDER'
          errors.push
            field: 'insurees'
            message: "One policy holder per contract. Person #{insuree.personId} cannot be policy holder."
        dbContract.insurees.push insuree

      if not _.isEmpty errors
        return res.status(400).send(errors)

      dbContract.save (err, updatedContract) ->
        console.log err
        return res.sendStatus 500 if err
        return res.send updatedContract.toJson()


  app.post '/contract/:contractId/remove/:personId', (req, res) ->
    {contractId, personId} = req.params
    Contract.findById contractId, (err, contract) ->
      return res.sendStatus(500) if err
      return res.sendStatus(404) if not contract
      keyedInsurees = _.keyBy contract.insurees, (insuree) -> insuree.personId
      insuree = keyedInsurees[personId]
      if not insuree
        return res.send({
          field: 'personId'
          message: "Cannot find person #{personId}."
        }).status(404)
      if insuree.relationship == 'POLICY_HOLDER'
        return res.send({
          field: 'personId'
          message: "Person #{personId} is policy holder. Cannot remove policy holder."
        }).status(400)

      _.remove contract.insurees, (insuree) -> insuree.personId.toString() == personId
      contract.markModified 'insurees'
      contract.save (err, updatedContract) ->
        return res.sendStatus 500 if err
        console.log updatedContract
        return res.send updatedContract.toJson()