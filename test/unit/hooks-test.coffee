require 'coffee-errors'
sinon = require 'sinon'
{assert} = require 'chai'


Hooks = require '../../src/hooks'

describe 'Hooks', () ->

  describe '#before', () ->
    hooks = null

    before () ->
      hooks = new Hooks()
      hooks.before 'beforeHook', () ->
        ""

    it 'should add to hook collection', () ->
      assert.property hooks.beforeHooks, 'beforeHook'

  describe '#after', () ->
    hooks = null

    before () ->
      hooks = new Hooks()
      hooks.after 'afterHook', () ->
        ""

    it 'should add to hook collection', () ->
      assert.property hooks.afterHooks, 'afterHook'

  describe '#beforeAll', () ->
    hooks = null

    before () ->
      hooks = new Hooks()
      hooks.beforeAll () ->
        ""

    it 'should add to hook collection', () ->
      assert.lengthOf hooks.beforeAllHooks, 1

  describe '#afterAll', () ->
    hooks = null

    before () ->
      hooks = new Hooks()
      hooks.afterAll () ->
        ""

    it 'should add to hook collection', () ->
      assert.lengthOf hooks.afterAllHooks, 1

  describe '#beforeEach', () ->
    hooks = null

    before () ->
      hooks = new Hooks()
      hooks.beforeEach () ->
        ""

    it 'should add to hook collection', () ->
      assert.lengthOf hooks.beforeEachHooks, 1

  describe '#afterEach', () ->
    hooks = null

    before () ->
      hooks = new Hooks()
      hooks.afterEach () ->
        ""

    it 'should add to hook collection', () ->
      assert.lengthOf hooks.afterEachHooks, 1

  describe '#dumpHooksFunctionsToStrings', () ->
    hooks = null

    beforeEach () ->
      hooks = new Hooks()
      hook = (data, callback) ->
        return true

      hooks.beforeAll hook
      hooks.beforeEach hook
      hooks.before 'Transaction Name', hook
      hooks.after 'Transaction Name', hook
      hooks.afterEach hook
      hooks.afterAll hook


    it 'should return an object', () ->
      assert.isObject hooks.dumpHooksFunctionsToStrings()

    describe 'returned object', () ->
      properties = [
        'beforeAllHooks'
        'beforeEachHooks'
        'afterEachHooks'
        'afterAllHooks'
      ]

      for property in properties then do (property) ->
        it "should have property '#{property}'", () ->
          object = hooks.dumpHooksFunctionsToStrings()
          assert.property object, property

        it 'should be an array', () ->
          object = hooks.dumpHooksFunctionsToStrings()
          assert.isArray object[property]

        describe "all array members under property '#{property}'", () ->
          it 'should be a string', () ->
            object = hooks.dumpHooksFunctionsToStrings()
            for key, value of object[property] then do (key, value) ->
              assert.isString value, "on #{property}['#{key}']"

      properties = [
        'beforeHooks'
        'afterHooks'
      ]

      for property in properties then do (property) ->
        it "should have property '#{property}'", () ->
          object = hooks.dumpHooksFunctionsToStrings()
          assert.property object, property

        it 'should be an object', () ->
          object = hooks.dumpHooksFunctionsToStrings()
          assert.isObject object[property]

        describe 'each object value', () ->
          it 'should be an array', () ->
            object = hooks.dumpHooksFunctionsToStrings()
            for key, value of object[property] then do (key, value) ->
              assert.isArray object[property][key], "at hooks.dumpHooksFunctionsToStrings()[#{property}][#{key}]"

        describe 'each member in that array', () ->
          it 'should be a string', () ->
            object = hooks.dumpHooksFunctionsToStrings()
            for transactionName, funcArray of object[property] then do (transactionName, funcArray) ->
              for index, func of funcArray
                assert.isString object[property][transactionName][index], "at hooks.dumpHooksFunctionsToStrings()[#{property}][#{transactionName}][#{index}]"

