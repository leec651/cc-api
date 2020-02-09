mongoose = require 'mongoose'
Schema = mongoose.Schema
{RELATIONSHIP, QUALIFYING_EVENT}= require './constant'

module.exports =
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


