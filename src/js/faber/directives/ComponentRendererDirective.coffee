faber.directive 'faberComponentRenderer', ($rootScope, $http, $templateCache, $timeout, $compile, componentsService)->
  require: '^faberBlock'
  restrict: 'AE'
  scope:
    'block': '=faberComponentBlock'
  template: '<div></div>'

  link: ($scope, $element, $attrs, blockController)->
    $scope.component = null

    $scope.select = ()->
      $scope.component.selected($element, $scope.update) if $scope.component.selected

    $scope.unselect = ()->
      $scope.component.unselected($element, $scope.update) if $scope.component.unselected

    $scope.update = (content)->
      if content
        $scope.block.content = content

    $scope.$watch 'block.component', (val)->
      # retrieve the component's template and append it to the block
      $scope.component = componentsService.findById($scope.block.component)
      if $scope.block.component and $scope.component
        template = $scope.component.template
        $component = $compile(template)($scope)

        wrapper = $element.find('div')
        wrapper.empty()
        $element.find('div').append $component

        $scope.component.init($element, $scope.block.content, $scope.update) if $scope.component.init

#        $rootScope.$broadcast 'SelectBlock', null
        $scope.$broadcast 'SelectBlock', blockController.getScopeId()
#        $rootScope.$broadcast 'SelectComponent', blockController.getScopeId()

    $scope.$on 'SelectBlock', (evt, id)->
      if $scope.component
        unless id is blockController.getScopeId()
          $scope.unselect()
        else
          $scope.select()

