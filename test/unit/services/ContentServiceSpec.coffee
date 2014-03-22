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

  it 'should be able to save the data to cookie', ->
    @contentService.import sampleJson
    @contentService.save()

    expect(@cookieStore.get "#{@config.prefix}.data").toBe sampleJson