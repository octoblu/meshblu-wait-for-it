_           = require 'lodash'
async       = require 'async'
MeshbluHttp = require 'meshblu-http'

class WaitForIt
  constructor: (options) ->
    { meshbluConfig, @uuid, @times, @interval } = options
    throw new Error 'WaitForIt: requires meshbluConfig' unless meshbluConfig?
    throw new Error 'WaitForIt: requires device uuid' unless @uuid?
    @meshbluHttp = new MeshbluHttp meshbluConfig

  toChangeFrom: ({ key, value }, callback) =>
    async.retry { @times, @interval }, async.apply(@_fetchChangeFrom, { key, value }), callback

  toChangeTo: ({ key, value }, callback) =>
    async.retry { @times, @interval }, async.apply(@_fetchChangeTo, { key, value }), callback

  toExist: ({ key }, callback) =>
    async.retry { @times, @interval }, async.apply(@_fetchExist, { key }), callback

  toNotExist: ({ key }, callback) =>
    async.retry { @times, @interval }, async.apply(@_fetchNotExist, { key }), callback

  _fetchExist: ({ key }, callback) =>
    @_fetch (error, device) =>
      return callback error if error?
      value = _.get device, key
      return callback new Error "Expected `#{key}` to exist" unless value?
      callback null

  _fetchNotExist: ({ key }, callback) =>
    @_fetch (error, device) =>
      return callback error if error?
      value = _.get device, key
      return callback new Error "Expected `#{key}` to not exist" if value?
      callback null

  _fetchChangeFrom: ({ key, value }, callback) =>
    @_fetch (error, device) =>
      return callback error if error?
      current = _.get device, key
      if _.isEqual current, value
        return callback new Error "Expected `#{key}` to change from '#{JSON.stringify(value)}'"
      callback null

  _fetchChangeTo: ({ key, value }, callback) =>
    @_fetch (error, device) =>
      return callback error if error?
      expected = _.get device, key
      unless _.isEqual expected, value
        return callback new Error "Expected `#{key}` to change to '#{JSON.stringify(value)}'"
      callback null

  _fetch: (callback) =>
    @meshbluHttp.device @uuid, callback

module.exports = WaitForIt
