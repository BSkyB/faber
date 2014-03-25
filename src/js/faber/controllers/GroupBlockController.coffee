faber.controller 'GroupBlockController', ($controller, $scope, componentsService)->

  # extends BlockController
  $controller 'BlockController', {$scope: $scope}

  # retrieve available component list for the current block
  $scope.components = componentsService.findByType 'group'