mongoose = require 'mongoose'
Schema = mongoose.Schema
_ = require 'lodash'
Address = require './Address'
uuidv4 = require 'uuid/v4'

{ SEX, ETHNICITY, LANGUAGE } = './constant'

PersonSchema = new Schema(
  email:
    type: String
    required: true
    lowercase: true
    unique: true
  firstName: String
  middleName: String
  lastName: String
  dateOfBirth: Date
  sex:
    required: true
    type: String
    enum: SEX
    default: 'UNKNOWN'
  ethnicity:
    required: true
    type: String
    enum: ETHNICITY
    default: 'UNKNOWN'
  language:
    required: true
    type: String
    enum: LANGUAGE
    default: 'ENG'
  address: Address
  phone:
    type: String
    set: (v) -> _.replace(v, /-/g, '')
  createdAt:
    required: true
    type: Date
    default: Date.now
  deletedAt: Date
)

PersonSchema.pre 'save', (next) ->
  return next()

# PersonSchema.post 'save', (error, doc, next) ->
#   if error.name == 'MongoError' && error.code == 11000
#     return next new Error('There was a duplicate key error')
#   else
#     return next error

PersonSchema.methods =
  toJson: () ->
    person = this.toObject()
    person.id = person._id
    delete person.__v
    return person

PersonSchema.index {'email': 1}

module.exports = PersonSchema