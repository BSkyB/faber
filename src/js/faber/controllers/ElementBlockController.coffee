angular.module('faber').controller 'ElementBlockController', ()->

  # extends BlockController
  $controller('BlockController', {$scope: $scope})