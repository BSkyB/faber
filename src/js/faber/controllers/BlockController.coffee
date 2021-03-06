angular.module('faber').controller 'BlockController', ($rootScope, $scope, $log, componentsService, contentService) ->
  $scope.block or= {}

  $scope.component = null

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
      return true
    else
      $log.warn 'cannot find a component of the given name': block.component
      return false

  # Remove a child block
  $scope.remove = (block)->
    if confirm 'Are you sure you want to permanently remove this block?\n\nYou can\'t undo this action.'
      $scope.block.blocks.splice($scope.block.blocks.indexOf(block), 1)
      $rootScope.$broadcast 'BlockUpdated'

  # Insert a child block to the given index
  $scope.insert = (index, block)->
    if $scope.validateBlock block
      $scope.block.blocks.splice(index, 0, block)

  # Insert an empty group block to the given index
  $scope.insertGroup = (index)->
    $scope.block.blocks.splice(index, 0, {component: componentsService.findByType('group')[0].id})

  # Move a child block at from index to to index
  $scope.move = (from, to)->
    max = $scope.block.blocks.length
    if from >= 0 and from < max and to >= 0 and to < max
      $scope.block.blocks.splice to, 0, $scope.block.blocks.splice(from, 1)[0]
      $scope.$broadcast 'BlockMoved'
      $rootScope.$broadcast 'BlockUpdated'

  # ==================
  # WATCH
  # ==================

  # If the block's component data changes, find the component object and set it to the block
  $scope.$watch 'block.component', (val) ->
    if val
      component = componentsService.findById val

      if !component and componentsService.getAll().length > 0
        $log.warn 'cannot find a component of the given name': val
      else
        $scope.component = component or new FaberComponent()
        $rootScope.$broadcast 'BlockUpdated'

  # If block's content changes save it
  $scope.$watch 'block.content', ()->
    $rootScope.$broadcast 'BlockUpdated'
  , true

  # If a child block is added or removed save the changes
  $scope.$watch 'block.blocks', ()->
    $rootScope.$broadcast 'BlockUpdated'
