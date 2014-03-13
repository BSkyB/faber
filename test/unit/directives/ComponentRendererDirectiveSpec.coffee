describe 'Component Renderer Directive:', ->
  beforeEach module 'faber'

  it 'should be able to render the template of the given component', ->
    inject ($templateCache, $compile, $rootScope)->
      $templateCache.put 'sample-component.html', '<p>Sample Component</p>'

      scope = $rootScope.$new()
      scope.component =
        template: 'sample-component.html'
        type: 'element'
      element = $compile('<faber-component-renderer></faber-component-renderer>')(scope)
      scope.$digest()

      expect(element.text()).toBe 'Sample Component'