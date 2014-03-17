faber.controller 'BlockController', ($rootScope, $scope, $log, componentsService) ->
  $scope.block or= {}
  $scope.block.blocks or= []
  $scope.component or= new FaberComponent()
  $scope.renderer or={}

  $scope.expanded = !!$rootScope.expanded

  $scope.$on 'CollapseAll', (evt)->
    $scope.expanded = false

  $scope.$on 'ExpandAll', (evt)->
    $scope.expanded = true

  # When a child block fire this event with itself as an argument,
  # the parent block will pick the event and stop it to propagate more
  # and remove the child block from its children
  $scope.$on 'RemoveChildBlock', (evt, block)->
    unless evt.targetScope is $scope
      evt.stopPropagation()
      $scope.remove(block)

  # retrieve available component list for the current block
  $scope.components = ()->
    ret = []

    if $scope.isTopLevel
      # if the block is top level block (editor level) it can use all the components
      ret = componentsService.getAll()
    else
      # if it is not a top lebel block and 'element' component block, it can not have any component block as a child
      # but if it is a 'group' block, it can have non top level only component block as a child
      ret = if $scope.component.type is 'element' then [] else componentsService.findNonTopLevelOnly()

    return ret

  # Check if the component of the block is valid component and the block has all necessary information
  $scope.validateBlock = (block)->
    result = true
    if angular.isString(block.component)
      # if the block's component parameter is the path to the template
      component = componentsService.findByTemplate block.component
    else if angular.isObject(block.component) and angular.isString(block.component.template)
      # if the block's component is already set to a component object and has path to the template
      component = componentsService.findByTemplate block.component.template

    if component
      # if the component is top level only component but the block is not a top level block, it's invalid block
      isTopLevelScope = $scope.isTopLevel
      result &= !(component.topLevelOnly) or (component.topLevelOnly and isTopLevelScope)
    else
      # if the component doesn't exist, it's invalid block
      return false

    # block.inputs should be either undefined or an object
    # TODO  this may not necessary depends on how the components implemented
    result &= (!block.inputs or angular.isObject(block.inputs))

  # If it's valid block data then add to the blocks otherwise warn the user and do not add it to the list
  $scope.add = (block)->
    if $scope.validateBlock block
      $scope.block.blocks or= []
      $scope.block.blocks.push block
      return true
    else
      $log.warn 'cannot find a component of the given template': block.component
      return false

  # Remove a child block
  $scope.remove = (block)->
    if confirm 'Are you sure you want to permanently remove this block?\n\nYou can’t undo this action.'
      $scope.block.blocks.splice($scope.block.blocks.indexOf(block), 1)

  # Insert a child block to the given index
  $scope.insert = (index, block)->
    if $scope.validateBlock block
      $scope.block.blocks.splice(index, 0, block)

  # Emit RemoveChildBlock event with itself so its parent block can remove it
  $scope.removeSelf = ()->
    $scope.$emit 'RemoveChildBlock', $scope.block

  # if the block's component data changes, find the component object and set it to the block
  $scope.$watch 'block.component', (val) ->
    component = componentsService.findByTemplate val

    if !component and componentsService.getAll().length > 0
      $log.warn 'cannot find a component of the given template': val
    else
      $scope.component = component or new FaberComponent()
