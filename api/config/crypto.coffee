
environment = process.env.NODE_ENV || 'development'
security = require("../../config/#{environment}/security")
helper = require('./helper')
delete security.jwt

config = helper(security)

module.exports = {
  passphrase: config.passphrase || ''
  iv: config.iv || ''
}