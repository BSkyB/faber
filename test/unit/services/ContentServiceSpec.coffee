describe 'ContentService:', ()->

  beforeEach module 'faber'

  beforeEach ->
    inject ($injector, $cookieStore, faberConfig)->
      @contentService = $injector.get 'contentService'
      @cookieStore = $cookieStore
      @config = faberConfig

  describe 'when initialised', ->
    it 'should be defined', ->
      expect(@contentService).toBeDefined()

  describe 'when import', ->
    it 'should check if it\'s array', ->
      importFail = @contentService.import '{"test": "test copy"}'
      importPass = @contentService.import '[{"test": "test copy"}]'

      expect(importFail).toBeFalsy()
      expect(importPass).toBeTruthy()

  describe 'when export', ->
    it 'should export to correct json format', ->
      @contentService.import sampleJson
      exported = @contentService.export()

      expect(exported).toBe sampleJson

  it 'should be able to clear the content blocks', ->
    @contentService.import sampleJson
    @contentService.clear()

    expect(@contentService.getAll().length).toBe 0

  describe 'when save content,', ->
    it 'should use \'faber\' as prefix if the prefix is not defined on the config', ->
      @contentService.import sampleJson
      @contentService.save()

      expect(@cookieStore.get 'faber.data').toBe sampleJson

    it 'should be able to save the data to cookie', ->
      @config.prefix = 'prefix-test'
      @contentService.import sampleJson
      @contentService.save()

      expect(@cookieStore.get 'faber.data').toBeUndefined()
      expect(@cookieStore.get 'prefix-test.data').toBe sampleJson

  describe 'when load content,', ->
    beforeEach ->
      @contentService.import sampleJson
      @contentService.save()

    it 'should be able to load the saved content', ->
      expect(@contentService.load 'faber.data').toBe sampleJson

    it 'should import the loaded content to the content service', ->
      spyOn @contentService, 'import'
      json = @contentService.load 'faber.data'

      expect(@contentService.import).toHaveBeenCalledWith json

  it 'should be able to remove the saved content', ->
    @contentService.import sampleJson
    @contentService.save()

    expect(@contentService.load 'faber.data').toBe sampleJson

    @contentService.removeSavedData()

    expect(@contentService.load 'faber.data').toBeUndefined