faber.controller 'BlockController', ($rootScope, $scope, $log, componentsService, contentService) ->
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
    if $scope.block.blocks.indexOf(block) >= 0
      evt.stopPropagation()
      $scope.remove(block)

  # When a child block fire this event with itself and destination index as arbuments,
  # the parent block will pick the event and stop it to propagate more
  # and mobe the child block to the destination to re-order its children
  $scope.$on 'MoveChildBlock', (evt, block, to)->
    if $scope.block.blocks.indexOf(block) >= 0
      evt.stopPropagation()
      $scope.move $scope.block.blocks.indexOf(block), to

  # retrieve available component list for the current block
  $scope.components = componentsService.getAll()

  # Check if the component of the block is valid component and the block has all necessary information
  $scope.validateBlock = (block)->
    result = true
    if angular.isString(block.component)
      # if the block's component parameter is the name of the template
      component = componentsService.findById block.component
    else if angular.isObject(block.component) and angular.isString(block.component.id)
      # if the block's component is already set to a component object and has path to the template
      component = componentsService.findById block.component.id

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
#      contentService.save()
      return true
    else
      $log.warn 'cannot find a component of the given name': block.component
      return false

  # Remove a child block
  $scope.remove = (block)->
    if confirm 'Are you sure you want to permanently remove this block?\n\nYou can\'t undo this action.'
      $scope.block.blocks.splice($scope.block.blocks.indexOf(block), 1)
      contentService.save()

  # Insert a child block to the given index
  $scope.insert = (index, block)->
    if $scope.validateBlock block
      $scope.block.blocks.splice(index, 0, block)

  # Move a child block at from index to to index
  $scope.move = (from, to)->
    max = $scope.block.blocks.length
    if from >= 0 and from < max and to >= 0 and to < max
      $scope.block.blocks.splice to, 0, $scope.block.blocks.splice(from, 1)[0]
      $scope.$broadcast 'BlockMoved'
      contentService.save()

  # Emit RemoveChildBlock event with itself so its parent block can remove it
  $scope.removeSelf = ()->
    $scope.$emit 'RemoveChildBlock', $scope.block

  # Edmit MoveChildBlock event with destination index so its parent block can move it to the new index
  $scope.moveSelf = (to)->
    $scope.$emit 'MoveChildBlock', $scope.block, to

  # If the block's component data changes, find the component object and set it to the block
  $scope.$watch 'block.component', (val) ->
    component = componentsService.findById val

    if !component and componentsService.getAll().length > 0
      $log.warn 'cannot find a component of the given name': val
    else
      $scope.component = component or new FaberComponent()
      contentService.save()

  # If block's content changes save it
  $scope.$watch 'block.content', ()->
    contentService.save()

  # If a child block is added or removed save the changes
  $scope.$watch 'block.blocks', ()->
    contentService.save()

