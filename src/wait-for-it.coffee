_           = require 'lodash'
async       = require 'async'
MeshbluHttp = require 'meshblu-http'

class WaitForIt
  constructor: (options) ->
    { meshbluConfig, @uuid } = options
    throw new Error 'WaitForIt: requires meshbluConfig' unless meshbluConfig?
    throw new Error 'WaitForIt: requires device uuid' unless @uuid?
    @meshbluHttp = new MeshbluHttp meshbluConfig

  toChangeTo: ({ key, value }, callback) =>
    async.retry { times: 5, interval: 10 }, async.apply(@_fetchChange, { key, value }), callback

  toExist: ({key}, callback) =>
    async.retry { times: 5, interval: 10 }, async.apply(@_fetchExist, {key}), callback

  toNotExist: ({key}, callback) =>
    async.retry { times: 5, interval: 10 }, async.apply(@_fetchNotExist, {key}), callback

  _fetchExist: ({ key }, callback) =>
    @_fetch (error, device) =>
      return callback error if error?
      value = _.get device, key
      return callback new Error 'Expected property to exist' unless value?
      callback null

  _fetchNotExist: ({ key }, callback) =>
    @_fetch (error, device) =>
      return callback error if error?
      value = _.get device, key
      return callback new Error 'Expected property to not exist' if value?
      callback null

  _fetchChange: ({ key, value }, callback) =>
    @_fetch (error, device) =>
      return callback error if error?
      expected = _.get device, key
      unless _.isEqual expected, value
        return callback new Error 'Expected property to change'
      callback null

  _fetch: (callback) =>
    @meshbluHttp.device @uuid, callback

module.exports = WaitForIt
