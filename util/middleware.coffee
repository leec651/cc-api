_ = require 'lodash'
validator = require 'validator'
ssn = require 'ssn-validator'

typeValidator = {}
typeValidator[String] = _.isString
typeValidator[Number] = _.isNumber
typeValidator[Array] = _.isArray
typeValidator[Date] = _.isDate
typeValidator[Object] = _.isPlainObject

formatter =
  email: validator.isEmail
  ssn: ssn.isValid


###
{
  date: {required, type}
  user: {
    name: {required, type}
    email: {required, type}
  }
}
require: true / false
type: [String, Number, Object, Array, Date]
###
validateHelper = (rules, input) ->
  map = {} # used to make sure there is no recursive object
  errors = []
  for key, {required, type, options, format} of rules
    value = input[key]
    if !required
      continue if !value
    else
      if !value
        errors.push
          path: key
          message: "Value is required"
      else
        if !typeValidator[type](value)
          errors.push
            path: key
            message: "[#{key}] must be [#{type.name}]"
        if options and !(value in options)
          errors.push
            path: key
            message: "#[#{value}] is not a valid option for field [#{key}]"
        if format and !formatter[format](value)
          errors.push
            path: key
            message: "[#{key}] is not in a valid format"
  return errors

validate = (rules) ->
  (req, res, next) ->
    # make sure all rules are supported
    for key, {type} of rules
      if !typeValidator[type]
        return res.sendStatus(500)

    for key, value of res.body
      res.body[key] = value.trim()

    errors = validateHelper rules, req.body
    if _.isEmpty errors
      return next()
    else
      return res.status(400).send({errors})

module.exports =
  validate: validate
  format: _.mapValues formatter, (v, k) -> k



