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
    async.retry { times: 5, interval: 100 }, async.apply(@_fetch, { key, value }), callback

  _didChangedTo: ({ key, value, device }) =>
    expected = _.get device, key
    return _.isEqual expected, value

  _fetch: ({ key, value }, callback) =>
    @meshbluHttp.device @uuid, (error, device) =>
      return callback error if error?
      unless @_didChangedTo { key, value, device }
        return callback new Error 'No Change'
      callback null

module.exports = WaitForIt
