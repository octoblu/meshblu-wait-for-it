_           = require 'lodash'
async       = require 'async'
MeshbluHttp = require 'meshblu-http'

class WaitForIt
  constructor: (options) ->
    { meshbluConfig, @times, @interval } = options
    throw new Error 'WaitForIt: requires meshbluConfig' unless meshbluConfig?
    @times ?= 100
    @interval ?= 20
    @meshbluHttp = new MeshbluHttp meshbluConfig

  toChangeFrom: ({ uuid, key, value }, callback) =>
    async.retry { @times, @interval }, async.apply(@_fetchChangeFrom, { uuid, key, value }), callback

  toChangeTo: ({ uuid, key, value }, callback) =>
    async.retry { @times, @interval }, async.apply(@_fetchChangeTo, { uuid, key, value }), callback

  toExist: ({ uuid, key }, callback) =>
    async.retry { @times, @interval }, async.apply(@_fetchExist, { uuid, key }), callback

  toNotExist: ({ uuid, key }, callback) =>
    async.retry { @times, @interval }, async.apply(@_fetchNotExist, { uuid, key }), callback

  _fetchExist: ({ uuid, key }, callback) =>
    @_fetch { uuid }, (error, device) =>
      return callback error if error?
      value = _.get device, key
      return callback new Error "Expected `#{key}` to exist" unless value?
      callback null

  _fetchNotExist: ({ uuid, key }, callback) =>
    @_fetch { uuid }, (error, device) =>
      return callback error if error?
      value = _.get device, key
      return callback new Error "Expected `#{key}` to not exist" if value?
      callback null

  _fetchChangeFrom: ({ uuid, key, value }, callback) =>
    @_fetch { uuid }, (error, device) =>
      return callback error if error?
      current = _.get device, key
      if _.isEqual current, value
        return callback new Error "Expected `#{key}` to change from '#{JSON.stringify(value)}'"
      callback null

  _fetchChangeTo: ({ uuid, key, value }, callback) =>
    @_fetch { uuid }, (error, device) =>
      return callback error if error?
      expected = _.get device, key
      unless _.isEqual expected, value
        return callback new Error "Expected `#{key}` to change to '#{JSON.stringify(value)}'"
      callback null

  _fetch: ({ uuid }, callback) =>
    @meshbluHttp.device uuid, callback

module.exports = WaitForIt
