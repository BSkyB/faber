faber.directive 'faberGroupBlock', (componentsService) ->
  restrict: 'E'
  require: '^faberBlock'
  templateUrl: 'faber-group-block.html'
  controller: 'GroupBlockController'

  link: ($scope, $element, attrs, blockController)->
    $scope.$watch 'component', (val)->
      if val
        $scope.currentComponent = val.id

    $scope.$watch 'currentComponent', (val)->
      unless val is $scope.component.id
        $scope.block.component = val
        blockController.select()
#        $scope.component = componentsService.findById val