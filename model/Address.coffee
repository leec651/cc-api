Address =
  _id: false
  address1: String
  address2: String
  city: String
  state: String
  zip: String
  country: String # ISO 3166 country code

  createdAt:
    required: true
    type: Date
    default: Date.now
  deletedAt: Date

module.exports = Address
