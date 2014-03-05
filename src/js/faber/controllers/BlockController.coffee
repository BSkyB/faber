faber.controller 'BlockController', ($scope)->
  newBlock = (inputs, component, type)->
    'inputs': inputs
    'component': component
    'type': type

  validateBlock = (block)->
    angular.isObject(block.inputs) and angular.isString(block.component) and (block.type is 'element' or block.type is 'group')

  $scope.blocks = []

  $scope.add = (block)->
    if validateBlock block
      $scope.blocks.push block
      return true
    else
      return false

  $scope.remove = (block)->
    $scope.blocks.splice($scope.blocks.indexOf(block), 1)