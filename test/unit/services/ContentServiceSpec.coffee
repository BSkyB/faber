describe 'ContentService:', ()->

  beforeEach module 'faber'

  beforeEach ->
    inject ($injector)->
      @contentService = $injector.get 'contentService'

  describe 'when initialised', ->
    it 'should be defined', ->
      expect(@contentService).toBeDefined()

  describe 'when import', ->
    it 'should check if it\'s array', ->
      importError = @contentService.import '{"test": "test copy"}'
      importPass = @contentService.import '[{"test": "test copy"}]'

      expect(importError).toBeFalsy()
      expect(importPass).toBeTruthy()

  describe 'when export', ->
    it 'should export to correct json format', ->
      @contentService.import sampleJson
      exported = @contentService.export()

      expect(exported).toBe sampleJson
