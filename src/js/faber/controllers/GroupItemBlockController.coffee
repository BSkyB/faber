angular.module('faber').controller 'GroupItemBlockController', ($rootScope, $controller, $scope, componentsService)->
  # extends BlockController
  $controller 'BlockController', {$scope: $scope}

  $scope.block.blocks or= []

  $scope.components = componentsService.findByType 'element'