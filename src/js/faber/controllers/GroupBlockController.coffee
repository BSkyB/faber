angular.module('faber').controller 'GroupBlockController', ($rootScope, $controller, $scope, componentsService)->
  # extends BlockController
  $controller 'BlockController', {$scope: $scope}

  $scope.block.blocks or= []

  # retrieve available component list for the current block
  $scope.components = [
    name: 'Item'
    id: 'group-item'
    template: ''
  ]

  # retrieve available group component list for the current block an be switched
  $scope.groupComponents = componentsService.findByType 'group'

  # Insert an empty group item glock in to a group block
  $scope.insertGroupItem = (index)->
    groupItem =
      blocks: []
    $scope.block.blocks.splice(index, 0, groupItem)