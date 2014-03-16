faber.directive 'faberComponents', ($rootScope) ->
  restrict: 'AE'
  templateUrl: 'faber-components.html'

  link: ($scope, $element, attrs)->
    $scope.showingComponents = angular.isUndefined $scope.$index

    $scope.$watch 'showingComponents', (newValue)->
      if newValue
        $rootScope.$broadcast 'ShowComponents', $scope.$id

    $scope.$on 'ShowComponents', (evt, id)->
      unless id is $scope.$id
        $scope.showingComponents = false

    $scope.insertBlock = (evt, comp)->
      evt.stopPropagation()

      $scope.showingComponents = false

      insertTo = $scope.$index + 1 or 0
      $scope.insert insertTo, comp

    $scope.toggleComponents = ()->
      $scope.showingComponents = !$scope.showingComponents