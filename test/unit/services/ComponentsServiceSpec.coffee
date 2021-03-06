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

        @invalid =
          ()->
            test: "test copy"
        @invalidTemplate =
          ()->
            id: null
            type: 'group'
        @invalidType =
          ()->
            id: 'a-component'
            type: 'no idea what this is'
        @valid =
          ()->
            id: 'a-component'
            type: 'group'

        @componentsService.init [@invalid,@invalidTemplate, @invalidType, @valid]

      afterEach ->
        inject ($log)->
          $log.reset()

      it 'should warn', ->
        logs = @log.warn.logs

        expect(logs.length).toBe 3
        expect(logs).toContain ['invalid': @invalid]
        expect(logs).toContain ['invalid': @invalidTemplate]
        expect(logs).toContain ['invalid': @invalidType]

      it 'should store only valid components', ->
        components = @componentsService.getAll()

        expect(components.length).toBe 1
        expect(components).toContain new @valid()

    it 'should be able to find components of given type', ->
      @componentsService.init [
        ()->
          id: 'a-component'
          type: 'element'
      ,
        ()->
          id: 'b-component'
          type: 'element'
      ,
        ()->
          id: 'c-component'
          type: 'element'
      ,
        ()->
          id: 'd-component'
          type: 'group'
      ,
        ()->
          id: 'e-component'
          type: 'group'
      ]

      elements = @componentsService.findByType 'element'
      groups = @componentsService.findByType 'group'

      expect(elements.length).toBe 3
      expect(groups.length).toBe 2

    describe 'when finding a component using id,', ->
      beforeEach ->
        @input =
          ()->
            id: 'component1'
            type: 'element'
        @componentsService.init [ @input ]

      it 'should be able to find component of given id', ->
        component = @componentsService.findById 'component1'
        expect(component).toEqual new @input()

      it 'should return null if it cannot find', ->
        component = @componentsService.findById 'test component'

        expect(component).toBe null

    describe 'when finding components with top level only setting,', ->
      beforeEach ->
        @componentsService.init [
          ()->
            id: 'a-component'
            type: 'element'
            topLevelOnly: true
        ,
          ()->
            id: 'b-component'
            type: 'element'
        ,
          ()->
            id: 'c-component'
            type: 'element'
        ,
          ()->
            id: 'd-component'
            type: 'group'
            topLevelOnly: true
        ,
          ()->
            id: 'e-component'
            type: 'group'
        ]

      it 'should be able to find all top level only components', ->
        expect(@componentsService.findTopLevelOnly().length).toBe 2

      it 'should be able to find all non-top-level-only components', ->
        expect(@componentsService.findNonTopLevelOnly().length).toBe 3
