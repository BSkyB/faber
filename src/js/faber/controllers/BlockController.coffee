faber.controller 'BlockController', ($scope)->
  $scope.blocks = []

  $scope.add = (block)->
    $scope.blocks.push block
