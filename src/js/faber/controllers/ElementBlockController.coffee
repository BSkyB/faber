angular.module('faber').controller 'ElementBlockController', ($controller, $scope)->

  # extends BlockController
  $controller('BlockController', {$scope: $scope})

  $scope.block.content or= ''