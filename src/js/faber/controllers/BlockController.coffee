faber.controller 'BlockController', ($scope, contentService)->
  $scope.blocks = []

  $scope.add = (block)->
    if contentService.validateBlock block
      $scope.blocks.push block
      return true
    else
      return false

  $scope.remove = (block)->
    $scope.blocks.splice($scope.blocks.indexOf(block), 1)