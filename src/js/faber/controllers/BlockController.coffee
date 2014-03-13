faber.controller 'BlockController', ($rootScope, $scope, $log, componentsService) ->
  $scope.block or= {}
  $scope.block.blocks or= []
  $scope.component or= new FaberComponent()

  $scope.expanded = !!$rootScope.expanded

  $scope.$on 'CollapseAll', (evt)->
    $scope.expanded = false

  $scope.$on 'ExpandAll', (evt)->
    $scope.expanded = true

  $scope.$on 'RemoveChildBlock', (evt, block)->
    unless evt.targetScope is $scope
      evt.stopPropagation()
      $scope.remove(block)

  $scope.components = ()->
    if $scope.isTopLevel
      return componentsService.getAll()
    else
      return componentsService.findNonTopLevelOnly()

  $scope.validateBlock = (block) ->
    result = true
    if angular.isString(block.component)
      component = componentsService.findByTemplate block.component
    else if angular.isObject(block.component) and angular.isString(block.component.template)
      component = componentsService.findByTemplate block.component.template

    if component
      isTopLevelScope = $scope.isTopLevel
      result &= !(component.topLevelOnly) or (component.topLevelOnly and isTopLevelScope)
    else
      return false

    result &= (!block.inputs or angular.isObject(block.inputs))

  $scope.add = (block) ->
    if $scope.validateBlock block
      $scope.block.blocks or= []
      $scope.block.blocks.push block
      return true
    else
      $log.warn 'cannot find a component of the given template': block.component
      return false

  $scope.remove = (block) ->
    $scope.block.blocks.splice($scope.block.blocks.indexOf(block), 1)

  $scope.removeSelf = ()->
    $scope.$emit 'RemoveChildBlock', $scope.block

  $scope.$watch 'block.component', (val) ->
    component = componentsService.findByTemplate val

    if !component and componentsService.getAll().length > 0
      $log.warn 'cannot find a component of the given template': val
    else
      $scope.component = component or new FaberComponent()
