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

  it 'should be able to create a new block from the given inputs', ->
    newBlock =
      inputs:
        title: 'new title'
        body: 'new body'
      component: 'test-component'
      type: 'element'
    generated = @contentService.newBlock {title: 'new title', body: 'new body'}, 'test-component', 'element'

    expect(generated.inputs.title).toBe newBlock.inputs.title
    expect(generated.inputs.body).toBe newBlock.inputs.body
    expect(generated.component).toBe newBlock.component
    expect(generated.type).toBe newBlock.type

  it 'should be able to validate a block', ->
    validateFail = @contentService.validateBlock {test: "test copy"}
    invalidComponent = @contentService.validateBlock
      inputs:
        title: 'block title'
      component:
        title: 'invalid component type'
      type: 'element'
    invalidType = @contentService.validateBlock
      inputs:
        title: 'block title'
      component: 'a-component'
      type: 'no idea what this is'
    valid = @contentService.validateBlock
      inputs:
        title: 'block title'
      component: 'a-component'
      type: 'group'

    expect(validateFail).toBe false
    expect(invalidComponent).toBe false
    expect(invalidType).toBe false
    expect(valid).toBe true