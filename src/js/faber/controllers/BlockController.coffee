faber.controller 'BlockController', ($scope, $log, componentsService)->
  newBlock = (inputs, component, type)->
    'inputs': inputs
    'component': component

  validateBlock = (block)->
    result = true
    if angular.isString(block.component)
      component = componentsService.findByTemplate block.component
    else if angular.isObject(block.component) and angular.isString(block.component.template)
      component = componentsService.findByTemplate block.component.template

    if component
      isTopLevelScope = !$scope.$parent.$parent
      result &= !(component.topLevelOnly) or (component.topLevelOnly and isTopLevelScope)
    else
      return false

    result &= (!block.inputs or angular.isObject(block.inputs))

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
      $log.warn 'cannot find a component of the given template': block.component
      return false

  $scope.remove = (block)->
    $scope.block.blocks.splice($scope.block.blocks.indexOf(block), 1)

  $scope.$watch 'block.component', (val)->
    component = componentsService.findByTemplate val

    unless component
      $log.warn 'cannot find a component of the given template': val
    else
      $scope.component = component or new FaberComponent()