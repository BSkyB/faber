faber.controller 'GroupBlockController', ($controller, $scope, componentsService)->
  # extends BlockController
  $controller 'BlockController', {$scope: $scope}

  $scope.block.blocks or= []

  # retrieve available component list for the current block
  $scope.components = componentsService.findByType 'element'

  # retrieve available group component list for the current block an be switched
  $scope.groupComponents = componentsService.findByType 'group'

