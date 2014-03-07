faber.controller 'BlockController', ($scope, $log, componentsService)->
  newBlock = (inputs, component, type)->
    'inputs': inputs
    'component': component

  validateBlock = (block)->
    (angular.isObject(block.inputs) or !block.inputs) and (angular.isString(block.component) or !block.component)

  $scope.block or= {}
  $scope.block.blocks or= []
  $scope.component or= new FaberComponent()

  $scope.expandWatch =
    expanded: true

  $scope.$on 'CollapseAll', (evt)->
    $scope.expandWatch.expanded = false

  $scope.$on 'ExpandAll', (evt)->
    $scope.expandWatch.expanded = true

  $scope.add = (block)->
    if validateBlock block
      $scope.block.blocks or= []
      $scope.block.blocks.push block
      return true
    else
      return false

  $scope.remove = (block)->
    $scope.block.blocks.splice($scope.block.blocks.indexOf(block), 1)

  $scope.$watch 'block.component', (val)->
    component = componentsService.findByTemplate val

    unless component
      $log.warn 'cannot find a component of the given template': val

    $scope.component = component or new FaberComponent()