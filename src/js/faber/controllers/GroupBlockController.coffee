angular.module('faber').controller 'GroupBlockController', ($rootScope, $controller, $scope, componentsService)->
  # extends BlockController
  $controller 'BlockController', {$scope: $scope}

  $scope.block.blocks or= []

  # ensure the direct children of group are group-items
  for block in $scope.block.blocks
    block.component = "group-item"

  $scope.components = [componentsService.findById 'group-item']
  $scope.groupComponents = componentsService.findByType 'group'
