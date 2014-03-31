faber.directive 'faberComponents', ($rootScope, $filter, $timeout) ->
  buttonClickWithIndexReturn = (evt, $scope)->
    evt.stopPropagation() if evt
    $rootScope.$broadcast 'SelectBlock', null
    $scope.showingComponents = false
#    return $scope.$index + 1 or 0
    return if $scope.isGroupItemBlock and $scope.isExpanded then $scope.$index + 1 else $scope.block.blocks.length

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
      evt.stopPropagation() if evt
      $scope.showingComponents = false
      index = if $scope.isExpanded then $scope.$index + 1 else $scope.block.blocks.length

      if $scope.isGroupItemBlock
        $scope.expand()

        # if it is a group item block, wait for it's expanded and then insert the new block
        # otherwise, all other item blocks in the group will be selected
        # because they are technically inserted again by ng-if
        $timeout ()->
          $rootScope.$broadcast 'SelectBlock', null
          $scope.insert index, comp
      else
        $rootScope.$broadcast 'SelectBlock', null
        $scope.insert index, comp

    $scope.insertGroupBlock = (evt)->
      $scope.insertGroup buttonClickWithIndexReturn(evt, $scope)

    $scope.insertGroupItemBlock = (evt)->
      $scope.insertGroupItem buttonClickWithIndexReturn(evt, $scope)

    $scope.toggleComponents = (evt)->
      evt.stopPropagation() if evt
      $scope.showingComponents = !$scope.showingComponents