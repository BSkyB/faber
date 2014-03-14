faber.directive 'faberComponents', ($rootScope) ->
  restrict: 'AE'
  templateUrl: 'faber-components.html'

  link: ($scope, $element, attrs)->
    $scope.componentsExpanded = true

    $scope.$watch 'selectWatch', (newValue)->
      if newValue is $scope.$id
        $rootScope.expandedComponents = newValue

    $rootScope.$watch 'expandedComponents', (newValue)->
      $scope.componentsExpanded = !!newValue and newValue is $scope.$id
      $scope.selectWatch = null

    $scope.addBlock = (comp)->
      $scope.add comp
      $scope.componentsExpanded = false
      $scope.selectWatch = null