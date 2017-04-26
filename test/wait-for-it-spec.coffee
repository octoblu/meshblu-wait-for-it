{describe,it,beforeEach,afterEach,expect} = global
_                   = require 'lodash'
uuid                = require 'uuid'
getPort             = require 'rand-port'
MeshbluServer       = require 'meshblu-server'
MeshbluHttp         = require 'meshblu-http'

MeshbluServerConfig = require './fixtures/meshblu-server-config.coffee'
WaitForIt           = require '../'

describe 'WaitForIt', ->
  beforeEach 'meshblu-server prepare', (done) ->
    getPort (@port) =>
      @meshbluServerConfig = new MeshbluServerConfig { @port, name: uuid.v1() }
      @meshbluServer = new MeshbluServer @meshbluServerConfig.toJSON()
      @meshbluServer.prepare done

  beforeEach 'meshblu-service run', (done) ->
    @meshbluServer.run done

  beforeEach 'register meshblu config', (done) ->
    meshbluConfig = {
      hostname: 'localhost'
      protocol: 'http'
      port: @port
    }
    meshbluHttp = new MeshbluHttp meshbluConfig
    meshbluHttp.register { type: 'main-device' }, (error, device) =>
      return done error if error?
      @meshbluConfig = _.clone meshbluConfig
      @meshbluConfig.uuid = device.uuid
      @meshbluConfig.token = device.token
      @meshbluHttp = new MeshbluHttp @meshbluConfig
      done()

  beforeEach 'sut', ->
    @sut = new WaitForIt({
      @meshbluConfig
      interval: 10
    })

  afterEach 'stop meshblu-server', (done) ->
    @meshbluServer.destroy done

  describe '->toChangeTo', ->
    beforeEach 'register device', (done) ->
      @meshbluHttp.register { type: 'test-device' }, (error, device) =>
        return done error if error?
        @uuid = device.uuid
        done error

    describe 'when the device changes', ->
      beforeEach 'do it', (done) ->
        _.delay =>
          query = { changed: 'yes' }
          @meshbluHttp.update @uuid, query, (error) =>
            return done error if error?
        , 50
        @sut.toChangeTo { @uuid, key: 'changed', value: 'yes' }, (@error, @device) =>
          done()

      it 'should not have an error', ->
        expect(@error).to.not.exist

      it 'should return the device', (done) ->
        @meshbluHttp.device @uuid, (error, device) =>
          return done error if error?
          expect(@device).to.deep.equal device
          done()

    describe 'when a different device property changes', ->
      beforeEach 'register device', (done) ->
        @meshbluHttp.register { type: 'test-device' }, (error, device) =>
          return done error if error?
          @uuid = device.uuid
          done error

      beforeEach 'do it', (done) ->
        _.delay =>
          query = { otherChangedProperty: 'maybe' }
          @meshbluHttp.update @uuid, query, (error) =>
            return done error if error?
        , 50
        @sut.toChangeTo { @uuid, key: 'otherChangedProperty', value: 'maybe' }, (@error, @device) =>
          done()

      it 'should not have an error', ->
        expect(@error).to.not.exist

      it 'should return the device', (done) ->
        @meshbluHttp.device @uuid, (error, device) =>
          return done error if error?
          expect(@device).to.deep.equal device
          done()

    describe 'when the property is already changed', ->
      beforeEach 'register device', (done) ->
        @meshbluHttp.register { type: 'test-device', changed: 'already-changed' }, (error, device) =>
          return done error if error?
          @uuid = device.uuid
          done error

      beforeEach 'do it', (done) ->
        @sut.toChangeTo { @uuid, key: 'changed', value: 'already-changed' }, (@error, @device) =>
          done()

      it 'should not have an error', ->
        expect(@error).to.not.exist

      it 'should return the device', (done) ->
        @meshbluHttp.device @uuid, (error, device) =>
          return done error if error?
          expect(@device).to.deep.equal device
          done()

    describe 'when the device does not change', ->
      beforeEach 'register device', (done) ->
        @meshbluHttp.register { type: 'test-device' }, (error, device) =>
          return done error if error?
          @uuid = device.uuid
          done error

      beforeEach 'do it', (done) ->
        @sut.toChangeTo { @uuid, key: 'changed', value: 'yes' }, (@error, @device) =>
          done()

      it 'should have an error', ->
        expect(@error).to.exist

      it 'should return the device', (done) ->
        @meshbluHttp.device @uuid, (error, device) =>
          return done error if error?
          expect(@device).to.deep.equal device
          done()

  describe '->toChangeFrom', ->
    describe 'when the device changes', ->
      beforeEach 'register device', (done) ->
        @meshbluHttp.register { type: 'test-device', changed: 'no' }, (error, device) =>
          return done error if error?
          @uuid = device.uuid
          done error

      beforeEach 'do it', (done) ->
        _.delay =>
          query = { changed: 'yes' }
          @meshbluHttp.update @uuid, query, (error) =>
            return done error if error?
        , 50
        @sut.toChangeFrom { @uuid, key: 'changed', value: 'no' }, (@error, @device) =>
          done()

      it 'should not have an error', ->
        expect(@error).to.not.exist

      it 'should return the device', (done) ->
        @meshbluHttp.device @uuid, (error, device) =>
          return done error if error?
          expect(@device).to.deep.equal device
          done()

    describe 'when a different device property changes', ->
      beforeEach 'register device', (done) ->
        @meshbluHttp.register { type: 'test-device', otherChangedProperty: 'idk' }, (error, device) =>
          return done error if error?
          @uuid = device.uuid
          done error

      beforeEach 'do it', (done) ->
        _.delay =>
          query = { otherChangedProperty: 'maybe' }
          @meshbluHttp.update @uuid, query, (error) =>
            return done error if error?
        , 50
        @sut.toChangeFrom { @uuid, key: 'otherChangedProperty', value: 'idk' }, (@error, @device) =>
          done()

      it 'should not have an error', ->
        expect(@error).to.not.exist

      it 'should return the device', (done) ->
        @meshbluHttp.device @uuid, (error, device) =>
          return done error if error?
          expect(@device).to.deep.equal device
          done()

    describe 'when the device does not change', ->
      beforeEach 'register device', (done) ->
        @meshbluHttp.register { type: 'test-device', changed: 'no' }, (error, device) =>
          return done error if error?
          @uuid = device.uuid
          done error

      beforeEach 'do it', (done) ->
        @sut.toChangeFrom { @uuid, key: 'changed', value: 'no' }, (@error, @device) =>
          done()

      it 'should have an error', ->
        expect(@error).to.exist

      it 'should return the device', (done) ->
        @meshbluHttp.device @uuid, (error, device) =>
          return done error if error?
          expect(@device).to.deep.equal device
          done()

  describe '->toExist', ->
    describe 'when the device property exists', ->
      beforeEach 'register device', (done) ->
        @meshbluHttp.register { type: 'test-device' }, (error, device) =>
          return done error if error?
          @uuid = device.uuid
          done error

      beforeEach 'do it', (done) ->
        _.delay =>
          query = { changed: 'yes' }
          @meshbluHttp.update @uuid, query, (error) =>
            return done error if error?
        , 50
        @sut.toExist { @uuid, key: 'changed' }, (@error, @device) =>
          done()

      it 'should not have an error', ->
        expect(@error).to.not.exist

      it 'should return the device', (done) ->
        @meshbluHttp.device @uuid, (error, device) =>
          return done error if error?
          expect(@device).to.deep.equal device
          done()

    describe 'when a different device property exists', ->
      beforeEach 'register device', (done) ->
        @meshbluHttp.register { type: 'test-device' }, (error, device) =>
          return done error if error?
          @uuid = device.uuid
          done error

      beforeEach 'do it', (done) ->
        _.delay =>
          query = { otherChangedProperty: 'maybe' }
          @meshbluHttp.update @uuid, query, (error) =>
            return done error if error?
        , 50
        @sut.toExist { @uuid, key: 'otherChangedProperty' }, (@error, @device) =>
          done()

      it 'should not have an error', ->
        expect(@error).to.not.exist

      it 'should return the device', (done) ->
        @meshbluHttp.device @uuid, (error, device) =>
          return done error if error?
          expect(@device).to.deep.equal device
          done()

    describe 'when the device property does not exist', ->
      beforeEach 'register device', (done) ->
        @meshbluHttp.register { type: 'test-device' }, (error, device) =>
          return done error if error?
          @uuid = device.uuid
          done error

      it 'should return the device', (done) ->
        @meshbluHttp.device @uuid, (error, device) =>
          return done error if error?
          expect(@device).to.deep.equal device
          done()

      beforeEach 'do it', (done) ->
        @sut.toExist { @uuid, key: 'changed' }, (@error, @device) =>
          done()

      it 'should have an error', ->
        expect(@error).to.exist

      it 'should return the device', (done) ->
        @meshbluHttp.device @uuid, (error, device) =>
          return done error if error?
          expect(@device).to.deep.equal device
          done()

  describe '->toNotExist', ->
    describe 'when the device property exists', ->
      beforeEach 'register device', (done) ->
        @meshbluHttp.register { type: 'test-device', changed: 'yes' }, (error, device) =>
          return done error if error?
          @uuid = device.uuid
          done error

      beforeEach 'do it', (done) ->
        _.delay =>
          query = { changed: null }
          @meshbluHttp.update @uuid, query, (error) =>
            return done error if error?
        , 50
        @sut.toNotExist { @uuid, key: 'changed' }, (@error, @device) =>
          done()

      it 'should not have an error', ->
        expect(@error).to.not.exist

      it 'should return the device', (done) ->
        @meshbluHttp.device @uuid, (error, device) =>
          return done error if error?
          expect(@device).to.deep.equal device
          done()

    describe 'when a different device property exists', ->
      beforeEach 'register device', (done) ->
        @meshbluHttp.register { type: 'test-device', otherChangedProperty: 'maybe' }, (error, device) =>
          return done error if error?
          @uuid = device.uuid
          done error

      beforeEach 'do it', (done) ->
        _.delay =>
          query = { otherChangedProperty: null }
          @meshbluHttp.update @uuid, query, (error) =>
            return done error if error?
        , 50
        @sut.toNotExist { @uuid, key: 'otherChangedProperty' }, (@error, @device) =>
          done()

      it 'should not have an error', ->
        expect(@error).to.not.exist

      it 'should return the device', (done) ->
        @meshbluHttp.device @uuid, (error, device) =>
          return done error if error?
          expect(@device).to.deep.equal device
          done()

    describe 'when the device property always exists', ->
      beforeEach 'register device', (done) ->
        @meshbluHttp.register { type: 'test-device', changed: 'yes' }, (error, device) =>
          return done error if error?
          @uuid = device.uuid
          done error

      beforeEach 'do it', (done) ->
        @sut.toNotExist { @uuid, key: 'changed' }, (@error, @device) =>
          done()

      it 'should have an error', ->
        expect(@error).to.exist

      it 'should return the device', (done) ->
        @meshbluHttp.device @uuid, (error, device) =>
          return done error if error?
          expect(@device).to.deep.equal device
          done()
