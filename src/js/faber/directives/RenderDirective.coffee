faber.directive 'faberRender', ($compile, componentsService)->
#  require: 'ngModel'
  restrict: 'AE'
  templateUrl: 'faber-render.html'
  scope:
    data: '=faberRenderBlock'

  link: ($scope, $element, $attrs)->

#    $scope.updateRendered = (content)->
#      if content
#        $scope.block.content = content
#
#    $scope.component = componentsService.findById($scope.block.component)
#    if $scope.component
#
#      template = $scope.component.template
#      $component = $compile(template)($scope)
#      $element.find('div').append $component
#
#      $scope.component.init($element, $scope.block.content, $scope.updateRendered) if $scope.component.init


#    $controller.$render = ->
#      $scope.component = componentsService.findById($controller.$viewValue.component)
#      if $scope.component
#        $scope.block = $controller.$viewValue
#
#        template = $scope.component.template
#        $component = $compile(template)($scope)
#        $element.find('div').append $component
#
#        $scope.component.init($element, $scope.block.content, angular.noop) if $scope.component.init