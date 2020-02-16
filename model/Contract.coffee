_ = require 'lodash'
uuidv4 = require 'uuid/v4'
mongoose = require 'mongoose'

Schema = mongoose.Schema
{
  ENROLLMENT_SOURCE
  RELATIONSHIP
} = require './constant'

Insuree =
  personId:
    type: Schema.Types.ObjectId
    ref: 'Person'
    required: true
  relationship:
    required: true
    type: String
    enum: RELATIONSHIP
  enrolledAt:
    required: true
    type: Date
    default: Date.now
  effecuatedAt: Date
  cancelledAt: Date
  terminatedAt: Date
  createdAt:
    required: true
    type: Date
    default: Date.now
  deletedAt: Date

ContractSchema = new Schema(
  policyId:
    type: String
    required: true
  passive_renewal:
    type: Boolean
    default: true
  source:
    required: true
    type: String
    enum: ENROLLMENT_SOURCE
  insurees: [Insuree]
    # type: Map
    # of: Insuree

  appliedAt:
    required: true
    type: Date
    default: Date.now
  createdAt:
    required: true
    type: Date
    default: Date.now
  deletedAt: Date
)

ContractSchema.pre 'save', (next) ->
  return next()

ContractSchema.methods =
  toJson: () ->
    contract = this.toObject()
    contract.id = contract._id
    for insuree in contract.insurees
      contract.policyHolder = insuree.personId if insuree.relationship == 'POLICY_HOLDER'
      insuree.id = insuree._id
      delete insuree._id
    contract.insurees = _.keyBy contract.insurees, 'personId'
    delete contract.__v
    delete contract._id
    return contract

ContractSchema.index {'insurees.personId': 1, deletedAt: -1}
ContractSchema.index {'policyId': 1, deletedAt: -1}
ContractSchema.index {'source': 1, deletedAt: -1}
ContractSchema.index {'passive_renewal': 1, deletedAt: -1}


module.exports = ContractSchema