faber.directive 'faberComponents', ($rootScope, $filter, componentsService) ->
  require: '^faberEditor'
  restrict: 'AE'
  templateUrl: 'faber-components.html'

  link: ($scope, $element, attrs)->
    $scope.showingComponents = angular.isUndefined $scope.$index
    $scope.showingGroupComponents = false

    $scope.hasGroupComponents = ()->
      groupComponents = $filter('filter') $scope.components, type: 'group', true
      return groupComponents.length > 0

    $scope.$watch 'showingComponents', (newValue)->
      if newValue
        $rootScope.$broadcast 'ShowComponents', $scope.$id

    $scope.$on 'ShowComponents', (evt, id)->
      unless id is $scope.$id
        $scope.showingComponents = false

    $scope.$on 'SelectBlock', (evt, id)->
      $scope.showingComponents = false

    $scope.insertBlock = (evt, comp)->
      evt.stopPropagation()

      $scope.showingComponents = false

      insertTo = $scope.$index + 1 or 0
      $scope.insert insertTo, comp

    $scope.insertGroupItemBlock = (evt)->
      evt.stopPropagation()

      $scope.showingComponents = false

      insertTo = $scope.$index + 1 or 0
      $scope.insertGroup insertTo

    $scope.toggleComponents = ()->
      $scope.showingComponents = !$scope.showingComponents

#    $scope.toggleGroupComponents = (evt)->
#      evt.stopPropagation() if evt
#      $scope.showingGroupComponents = !$scope.showingGroupComponents