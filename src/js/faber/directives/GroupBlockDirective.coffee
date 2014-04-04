angular.module('faber').directive 'faberGroupBlock', () ->
  restrict: 'E'
  templateUrl: 'faber-group-block.html'
  controller: 'GroupBlockController'

  link: ($scope, $element, attrs)->
    $scope.$watch 'component', (val)->
      if val
        $scope.currentComponent = val.id

    $scope.$watch 'currentComponent', (val)->
      unless val is $scope.component?.id
        $scope.block.component = val
        $scope.isSelected = true