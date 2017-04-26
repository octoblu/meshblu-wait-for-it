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
      unless value?
        error = new Error("Expected `#{key}` to exist but got #{value}")
        return callback error, device
      callback null, device

  _fetchNotExist: ({ uuid, key }, callback) =>
    @_fetch { uuid }, (error, device) =>
      return callback error if error?
      value = _.get device, key
      if value?
        error = new Error("Expected `#{key}` to not exist but got #{value}")
        return callback error, device
      callback null, device

  _fetchChangeFrom: ({ uuid, key, value }, callback) =>
    @_fetch { uuid }, (error, device) =>
      return callback error if error?
      current = _.get device, key
      if _.isEqual current, value
        error = new Error("Expected `#{key}` to change from #{JSON.stringify(value)} but got #{JSON.stringify(current)}")
        return callback error, device
      callback null, device

  _fetchChangeTo: ({ uuid, key, value }, callback) =>
    @_fetch { uuid }, (error, device) =>
      return callback error if error?
      current = _.get device, key
      unless _.isEqual current, value
        error = new Error("Expected `#{key}` to change to #{JSON.stringify(value)} but got #{JSON.stringify(current)}")
        return callback error, device
      callback null, device

  _fetch: ({ uuid }, callback) =>
    @meshbluHttp.device uuid, callback

module.exports = WaitForIt
