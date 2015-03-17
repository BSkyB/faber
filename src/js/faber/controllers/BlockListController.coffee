angular.module('faber').controller 'BlockListController', ($rootScope, $controller, $scope, componentsService)->
  # extends BlockController
  $controller 'BlockController', {$scope: $scope}

  $scope.blocks or= []
  $scope.components or= componentsService.findByType 'element'

