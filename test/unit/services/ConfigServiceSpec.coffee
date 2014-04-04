describe 'ConfigService:', ()->
  configService = null
  rootScope = null

  faberConfig =
    # (boolean) Default expanded flag for child blocks
    expanded: false

    # (array) List of components to be imported and managed by components service
    components: [
      RichTextComponent
    ,
      ()->
        name: 'Element Component'
        id: 'element-component'
        type: 'element'
        template: '<p>element component</p>'
    ,
      OrderedListComponent
    ,
      ()->
        name: 'Group Component'
        id: 'group-component'
        type: 'group'
        template: '<ul><li>group component itenm</li></ul>'
    ]

  beforeEach module 'faber'

  beforeEach ->
    inject ($injector, $rootScope)->
      configService = $injector.get 'configService'

      rootScope = $rootScope

  it 'should set default config if no config is given', ->
    defaultConfig = configService.get()

    expect(configService.get).toBeDefined()
    expect(defaultConfig.expanded).toBe true
    expect(defaultConfig.prefix).toBe 'faber'
    expect(defaultConfig.components.length).toBe 2

  describe 'if given a new config', ->
    config = null

    beforeEach ->
      spyOn rootScope, '$broadcast'

      faber.init faberConfig
      config = configService.get()

    it 'should set correct config if a config is given', ->
      expect(config.expanded).toBe false
      expect(config.components.length).toBe 4

    it 'should broadcast ConfigUpdated event', ->
      expect(rootScope.$broadcast).toHaveBeenCalled()