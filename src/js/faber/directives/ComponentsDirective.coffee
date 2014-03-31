faber.directive 'faberComponents', ($rootScope, $filter, $timeout) ->
  buttonClickWithIndexReturn = (evt, $scope)->
    evt.stopPropagation() if evt
    $rootScope.$broadcast 'SelectBlockOfIndex', null
    $scope.showingComponents = false
    return $scope.$index + 1 or 0

  restrict: 'AE'
  templateUrl: 'faber-components.html'

  link: ($scope, $element, attrs)->
    $scope.showingComponents = (angular.isUndefined $scope.$index) and $scope.isExpanded

    $scope.hasGroupComponents = ()->
      groupComponents = $filter('filter') $scope.components, type: 'group', true
      return groupComponents.length > 0

    $scope.$watch 'showingComponents', (newValue)->
      if newValue
        $rootScope.$broadcast 'ShowComponents', $scope.$id

    $scope.$watch 'isExpanded', (val)->
      if $scope.isGroupItemBlock
        if val
          if $scope.block.blocks.length is 0
            $scope.showingComponents = true
        else
          $scope.showingComponents = false

    $scope.$on 'ShowComponents', (evt, id)->
      unless id is $scope.$id
        $scope.showingComponents = false

    $scope.insertBlock = (evt, comp)->
      evt.stopPropagation() if evt
      $scope.showingComponents = false
      index = if $scope.isExpanded then ($scope.$index + 1 or 0) else $scope.block.blocks.length

      if $scope.isGroupItemBlock
        $scope.expand()

      $scope.insert index, comp

      $timeout ()->
        $rootScope.$broadcast 'SelectBlockOfIndex', $scope, index

    $scope.insertGroupBlock = (evt)->
      $scope.insertGroup buttonClickWithIndexReturn(evt, $scope)

    $scope.insertGroupItemBlock = (evt)->
      $scope.insertGroupItem buttonClickWithIndexReturn(evt, $scope)

    $scope.toggleComponents = (evt)->
      evt.stopPropagation() if evt
      $scope.showingComponents = !$scope.showingComponents