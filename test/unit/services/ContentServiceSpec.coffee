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

    it 'should be able to import a complicated JSON format', ->
      @contentService.import sampleJson

      expect(@contentService.export()).toBe sampleJson

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

      sample = angular.fromJson sampleJson
      saved = angular.fromJson @cookieStore.get('faber.data')

      expect(saved.length).toBe sample.length
      expect(angular.toJson(saved)).toBe angular.toJson(sample)

    it 'should be able to save the data to cookie', ->
      @config.prefix = 'prefix-test'
      @contentService.import sampleJson
      @contentService.save()

      sample = angular.fromJson sampleJson
      saved = angular.fromJson @cookieStore.get('prefix-test.data')

      expect(@cookieStore.get 'faber.data').toBeUndefined()
      expect(saved.length).toBe sample.length
      expect(angular.toJson(saved)).toBe angular.toJson(sample)

  describe 'when load content,', ->
    beforeEach ->
      @contentService.import sampleJson
      @contentService.save()

      @sample = angular.fromJson sampleJson
      @saved = angular.fromJson @cookieStore.get('prefix-test.data')

    it 'should be able to load the saved content', ->
      expect(angular.toJson(@saved)).toBe angular.toJson(@sample)

    it 'should import the loaded content to the content service', ->
      spyOn @contentService, 'import'
      json = @contentService.load 'faber.data'

      expect(@contentService.import).toHaveBeenCalledWith angular.toJson(@saved)

  it 'should be able to remove the saved content', ->
    @contentService.import sampleJson
    @contentService.save()

    expect(@contentService.load 'faber.data').toBe sampleJson

    @contentService.removeSavedData()

    expect(@contentService.load 'faber.data').toBeUndefined