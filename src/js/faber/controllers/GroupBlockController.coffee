angular.module('faber').controller 'GroupBlockController', ($rootScope, $controller, $scope, componentsService)->
  # extends BlockController
  $controller 'BlockController', {$scope: $scope}

  $scope.block.blocks or= []

  $scope.components = [componentsService.findById 'group-item']
  $scope.groupComponents = componentsService.findByType 'group'
