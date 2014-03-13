describe 'ComponentsService:', ()->

  beforeEach module 'faber'

  beforeEach ->
    inject ($injector)->
      @componentsService = $injector.get 'componentsService'

  describe 'when initialised,', ->
    it 'should be defined', ->
      expect(@componentsService).toBeDefined()

  describe 'if given a list of components,', ->
    describe 'if a given component is not valid,', ->
      beforeEach ->
        inject ($log)->
          $log.reset()
          @log = $log

        @invalid = {test: "test copy"}
        @invalidInputs =
          inputs: 'invalid'
          template: 'a-component'
          type: 'element'
        @invalidTemplate =
          inputs:
            title: 'block title'
          template: null
          type: 'group'
        @invalidType =
          inputs:
            title: 'block title'
          template: 'a-component'
          type: 'no idea what this is'
        @valid =
          inputs:
            title: 'block title'
          template: 'a-component'
          type: 'group'
        @validNoInputs =
          template: 'a-component'
          type: 'element'

        @componentsService.init [@invalid, @invalidInputs, @invalidTemplate, @invalidType, @valid, @validNoInputs]

      afterEach ->
        inject ($log)->
          $log.reset()

      it 'should warn', ->
        logs = @log.warn.logs

        expect(logs.length).toBe 4
        expect(logs).toContain ['invalid': @invalid]
        expect(logs).toContain ['invalid': @invalidInputs]
        expect(logs).toContain ['invalid': @invalidTemplate]
        expect(logs).toContain ['invalid': @invalidType]

      it 'should store other valid components', ->
        components = @componentsService.getAll()

        expect(components.length).toBe 2
        expect(components).toContain @valid
        expect(components).toContain @validNoInputs

    it 'should be able to find components of given type', ->
      @componentsService.init [
        template: 'a-component'
        type: 'element'
      ,
        template: 'b-component'
        type: 'element'
      ,
        template: 'c-component'
        type: 'element'
      ,
        template: 'd-component'
        type: 'group'
      ,
        template: 'e-component'
        type: 'group'
      ]

      elements = @componentsService.findByType 'element'
      groups = @componentsService.findByType 'group'

      expect(elements.length).toBe 3
      expect(groups.length).toBe 2

    describe 'when finding a component using template/id,', ->
      beforeEach ->
        @input =
          template: 'component1'
          type: 'element'
        @componentsService.init [ @input ]

      it 'should be able to find component of given template/id', ->
        component = @componentsService.findByTemplate 'component1'
        expect(component).toBe @input

      it 'should return null if it cannot find', ->
        component = @componentsService.findByTemplate 'test component'

        expect(component).toBe null

    describe 'when finding components with top level only setting,', ->
      beforeEach ->
        @componentsService.init [
          template: 'a-component'
          type: 'element'
          topLevelOnly: true
        ,
          template: 'b-component'
          type: 'element'
        ,
          template: 'c-component'
          type: 'element'
        ,
          template: 'd-component'
          type: 'group'
          topLevelOnly: true
        ,
          template: 'e-component'
          type: 'group'
        ]

      it 'should be able to find all top level only components', ->
        expect(@componentsService.findTopLevelOnly().length).toBe 2

      it 'should be able to find all non-top-level-only components', ->
        expect(@componentsService.findNonTopLevelOnly().length).toBe 3
