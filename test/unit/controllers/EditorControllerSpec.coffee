describe 'EditorController:', ->
  newConfig =
    expanded: false
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
    inject ($injector, $rootScope, $controller, $log)->
      @scope = $rootScope.$new()
      @editorController = $controller('EditorController', $scope: @scope)

      @configService = $injector.get 'configService'
      @contentService = $injector.get 'contentService'

      @config = @configService.get()

      @componentsService = $injector.get 'componentsService'
      @componentsService.init [
        ()->
          inputs:
            title: 'component title'
          id: 'a-component'
          name: 'Base component'
          type: 'element'
      ,
        ()->
          id: 'top-level-only-component'
          name: 'Base component'
          type: 'element'
          topLevelOnly: true
      ]

      @log = $log
      @log.reset()

  afterEach ->
    @log.reset()

  describe 'when initialised,', ->
    it 'should be defined', ->
      expect(@editorController).toBeDefined()

    it 'should get all initial blocks from content service', ->
      expect(@scope.block.blocks).toBe @contentService.getAll()

    it 'should config the editor with default settings', ->
      expect(@scope.isExpanded).toBe true
      expect(@scope.components.length).toBe 2

    it 'should update configurations if new config is available', ->
      faber.init newConfig

      expect(@scope.isExpanded).toBe false

    describe 'if given an element component,', ->
      beforeEach ->
        inject ()->
          @elementComp = ()->
            id: 'base-component'
            name: 'Base component'
            type: 'element'
            template: ''
          @configService.init
            components: [ @elementComp ]

      beforeEach ->
        inject ($injector, $rootScope, $controller)->
          @scope = $rootScope.$new()
          @controller = $controller('EditorController', $scope: @scope)
          @componentsService = $injector.get 'componentsService'

      afterEach ->
        @config = {}

      it 'should add it to the ComponentsService', ->
        allComponents = @componentsService.getAll()

        expect(allComponents.length).toBe 1
        expect(allComponents[0]).toEqual new @elementComp()

    describe 'if given an group component,', ->
      beforeEach ->
        inject (faberConfig)->
          @config = faberConfig
          @groupComp = ()->
            id: 'base-component'
            name: 'Base component'
            type: 'group'
          @configService.init
            components: [ @groupComp ]

      beforeEach ->
        inject ($injector, $rootScope, $controller)->
          @scope = $rootScope.$new()
          @controller = $controller('EditorController', $scope: @scope)
          @componentsService = $injector.get 'componentsService'

      afterEach ->
        @config = {}

      it 'should add it to the ComponentsService', ->
        allComponents = @componentsService.getAll()

        expect(allComponents.length).toBe 1
        expect(allComponents[0]).toEqual new @groupComp()

  describe 'when content is imported,', ->
    describe 'if all the block\'s have valid components,', ->
      it 'should add the blocks to the block list', ->
        @componentsService.init [
          ()->
            id: 'text'
            type: 'element'
        ,
          ()->
            id: 'image'
            type: 'element'
        ,
          ()->
            id: 'tabs'
            type: 'group'
        ]
        @contentService.import sampleJson

        expect(@scope.block.blocks.length).toBe 4
        expect(@scope.block.blocks[2].blocks.length).toBe 4
        expect(@scope.block.blocks[2].blocks[0].blocks.length).toBe 9

    # Exclude until group block is implemented
    describe 'if a block\'s component is not valid,', ->
      it 'should not add the block', ->
        @componentsService.init [
          ()->
            id: 'text'
            type: 'element'
        ,
          ()->
            id: 'tabs'
            type: 'group'
        ]
        @contentService.import '[
          {
            "inputs": {
              "contents": "text content"
            },
            "component": "text"
          },
          {
            "inputs": {
              "src": ""
            },
            "component": "INVALID"
          },
          {
            "component": "tabs",
            "blocks": [
              {
                "inputs": {
                  "title": "tab 1"
                },
                "blocks": [
                  {
                    "inputs": {
                      "contents": "text content"
                    },
                    "component": "text"
                  },
                  {
                    "inputs": {
                      "contents": "text content"
                    },
                    "component": "text"
                  }
                ]
              },
              {
                "inputs": {
                  "title": "tab 2"
                },
                "blocks": [
                  {
                    "inputs": {
                      "contents": "text content"
                    },
                    "component": "text"
                  },
                  {
                    "inputs": {
                      "contents": "text content"
                    },
                    "component": "text"
                  },
                  {
                    "inputs": {
                      "contents": "text content"
                    },
                    "component": "INVALID"
                  },
                  {
                    "inputs": {
                      "contents": "text content"
                    },
                    "component": "text"
                  }
                ]
              },
              {
                "inputs": {
                  "title": "tab 3"
                },
                "blocks": [
                  {
                    "inputs": {
                      "contents": "text content"
                    },
                    "component": "text"
                  },
                  {
                    "inputs": {
                      "contents": "text content"
                    },
                    "component": "text"
                  }
                ]
              }
            ]
          }
        ]'

        logs = @log.warn.logs

        expect(@scope.block.blocks.length).toBe 2
        expect(logs.length).toBe 2
        expect(logs).toContain ['cannot find a component with the given id': 'INVALID']

        expect(@scope.block.blocks[1].blocks.length).toBe 3
        expect(@scope.block.blocks[1].blocks[1].blocks.length).toBe 3

