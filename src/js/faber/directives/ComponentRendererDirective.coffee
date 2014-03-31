faber.directive 'faberComponentRenderer', ($rootScope, $http, $templateCache, $timeout, $compile, componentsService)->
  restrict: 'AE'
  template: '<div></div>'

  link: ($scope, $element, $attrs)->
    $scope.component = null

    $scope.selectRendered = ()->
      $scope.component.selected($element, $scope.updateRendered) if $scope.component.selected

    $scope.unselectRendered = ()->
      $scope.component.unselected($element, $scope.updateRendered) if $scope.component.unselected

    $scope.updateRendered = (content)->
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

        $scope.component.init($element, $scope.block.content, $scope.updateRendered) if $scope.component.init

    $scope.$on 'SelectBlockOfIndex', (evt, scope, index)->
      unless scope
        $scope.unselectRendered()
        return

      if scope.block.blocks[index] is $scope.block
        $scope.selectRendered()
      else
        $scope.unselectRendered()