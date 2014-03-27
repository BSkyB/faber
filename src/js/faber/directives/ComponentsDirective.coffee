faber.directive 'faberComponents', ($rootScope, $filter) ->
  buttonClickWithIndexReturn = (evt, $scope)->
    evt.stopPropagation() if evt
    $rootScope.$broadcast 'SelectBlock', null
    $scope.showingComponents = false
    return $scope.$index + 1 or 0

  restrict: 'AE'
  templateUrl: 'faber-components.html'

  link: ($scope, $element, attrs)->
    $scope.showingComponents = angular.isUndefined $scope.$index

    $scope.hasGroupComponents = ()->
      groupComponents = $filter('filter') $scope.components, type: 'group', true
      return groupComponents.length > 0

    $scope.$watch 'showingComponents', (newValue)->
      if newValue
        $rootScope.$broadcast 'ShowComponents', $scope.$id

    $scope.$on 'ShowComponents', (evt, id)->
      unless id is $scope.$id
        $scope.showingComponents = false

    $scope.insertBlock = (evt, comp)->
      $scope.insert buttonClickWithIndexReturn(evt, $scope), comp

    $scope.insertGroupBlock = (evt)->
      $scope.insertGroup buttonClickWithIndexReturn(evt, $scope)

    $scope.insertGroupItemBlock = (evt)->
      $scope.insertGroupItem buttonClickWithIndexReturn(evt, $scope)

    $scope.toggleComponents = (evt)->
      evt.stopPropagation() if evt
      $scope.showingComponents = !$scope.showingComponents