describe 'Faber Spec:', ->

  beforeEach module 'faber'

  beforeEach ->
    inject ($injector, $rootScope)->
      @contentService = $injector.get 'contentService'
      @rootScope = $rootScope

  describe 'to import a JSON,', ->
    it 'should have import function', ->
      expect(faber.import).toBeDefined()

    it 'should populate blocks from the imported JSON', ->
      spyOn @rootScope, '$broadcast'
      importResult = faber.import sampleJson

      expect(importResult).toBe true
      expect(@contentService.getAll().length).toBe 4
      expect(@rootScope.$broadcast).toHaveBeenCalled()

  describe 'to export to a JSON', ->
    it 'should have export function', ->
      expect(faber.export).toBeDefined()

    it 'should be able to export the blocks to a JSON', ->
      @contentService.import sampleJson
      spyOn @rootScope, '$broadcast'
      exported = faber.export()

      expect(exported).toBe sampleJson