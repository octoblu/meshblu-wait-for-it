{describe,it,beforeEach,afterEach,expect} = global
_                   = require 'lodash'
uuid                = require 'uuid'
MeshbluServer       = require 'meshblu-server'
MeshbluHttp         = require 'meshblu-http'

MeshbluServerConfig = require './meshblu-server-config.coffee'
WaitForIt           = require '../'

describe 'WaitForIt', ->
  beforeEach 'meshblu-server', (done) ->
    @meshbluServerConfig = new MeshbluServerConfig uuid.v1()
    @meshbluServer = new MeshbluServer @meshbluServerConfig.toJSON()
    @meshbluServer.prepare (error) =>
      return done error if error?
      @meshbluServer.run done

  beforeEach 'register meshblu config', (done) ->
    meshbluConfig = {
      hostname: 'localhost'
      protocol: 'http'
      port: @meshbluServerConfig.port()
    }
    meshbluHttp = new MeshbluHttp meshbluConfig
    meshbluHttp.register { type: 'main-device' }, (error, device) =>
      return done error if error?
      @meshbluConfig = _.clone meshbluConfig
      @meshbluConfig.uuid = device.uuid
      @meshbluConfig.token = device.token
      @meshbluHttp = new MeshbluHttp @meshbluConfig
      done()

  afterEach 'stop meshblu-server', (done) ->
    @meshbluServer.destroy done

  describe '->do', ->
    describe 'when the device changes', ->
      beforeEach 'register device', (done) ->
        @meshbluHttp.register { type: 'test-device' }, (error, @device) =>
          return done error if error?
          done error

      beforeEach 'do it', (done) ->
        done = _.once done
        _.delay =>
          query = { changed: 'yes' }
          @meshbluHttp.update @device.uuid, query, (error) =>
            return done error if error?
        , 100
        new WaitForIt({
          @meshbluConfig
          uuid: @device.uuid
        }).do (@error) =>
          done()

      it 'should not have an error', ->
        expect(@error).to.not.exist
