describe 'EditorController:', ->
  beforeEach module 'faber'

  beforeEach ->
    inject (faberConfig)->
      @config = faberConfig
      @config.expanded = false

  beforeEach ->
    inject ($injector, $rootScope, $controller, $log)->
      @scope = $rootScope.$new()
      @editorController = $controller('EditorController', $scope: @scope)
      @contentService = $injector.get 'contentService'

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

    describe 'when setting expanded flag,', ->
      beforeEach ->
        inject ($injector, $rootScope, $controller, faberConfig)->
          @config = faberConfig
          @config.expanded = false

          @scope = $rootScope
          spyOn @scope, '$broadcast'

          @controller = $controller('EditorController', $scope: @scope)
          @scope.$digest()

      afterEach ->
        @config = {}

      it 'set default expanded flag', ->
        expect(@scope.expanded).toBe false

      it 'should broadcast expand all event', ->
        expect(@scope.$broadcast).toHaveBeenCalledWith 'CollapseAll'

    describe 'if given an element component,', ->
      beforeEach ->
        inject (faberConfig)->
          @config = faberConfig
          @elementComp = ()->
            id: 'base-component'
            name: 'Base component'
            type: 'element'
            template: ''
          @config.components = [ @elementComp ]

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
          @config.components = [ @groupComp ]

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

  describe 'if content is imported,', ->
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

