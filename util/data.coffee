{RandomSSN} = require 'ssn'
_ = require 'lodash'
moment = require 'moment'
faker = require 'faker/locale/en_US'
{
  COBRA_TYPE
  ENROLLMENT_PERIOD_TYPE
  ENROLLMENT_SOURCE
  ENROLLMENT_SOURCE_TYPE
  FAMILY_TIER
} = require '../model/constant'

randomSSN = new RandomSSN()

date = (num) ->
  year = Math.random() * 100 % num
  day  = Math.random() * 100 % 265
  return moment().subtract(year, 'year').subtract(day, 'day').toDate()

person = () ->
  return
      firstName: faker.name.firstName()
      lastName: faker.name.lastName()
      ssn: randomSSN.value().toFormattedString()
      phone: faker.phone.phoneNumber('###-###-####')
      email: faker.internet.email()
      dateOfBirth: date(100)
      prefix: faker.name.prefix
      sex: if Math.random() * 10 % 2 == 0 then 'FEMALE' else 'MALE'
      address:
        address1: faker.address.streetAddress()
        address2: faker.address.secondaryAddress()
        city: faker.address.city()
        state: faker.address.stateAbbr()
        zip: faker.address.zipCode()
        country: faker.address.country()

contract = () ->
  return
    policyId: 'xxx'
    familyTier: FAMILY_TIER[_.random(FAMILY_TIER.length-1)]
    cobra: COBRA_TYPE[_.random(COBRA_TYPE.length-1)]
    enrollmentPeriodType: ENROLLMENT_PERIOD_TYPE[_.random(ENROLLMENT_PERIOD_TYPE.length-1)]
    enrollmentSource: ENROLLMENT_SOURCE[_.random(ENROLLMENT_SOURCE.length-1)]
    enrollmentSourceType: ENROLLMENT_SOURCE_TYPE[_.random(ENROLLMENT_SOURCE_TYPE.length-1)]
    applicationDate: date(10)
    applicationSignatureDate: date(10)

module.exports = { date, person, contract }