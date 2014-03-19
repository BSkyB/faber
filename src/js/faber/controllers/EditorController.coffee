faber.controller 'EditorController', ($rootScope, $scope, $controller, $log, contentService, componentsService, faberConfig) ->

  # extends BlockController
  $controller('BlockController', {$scope: $scope})

  $rootScope.$watch 'expanded', (newValue)->
    $rootScope.$broadcast if $rootScope.expanded then 'ExpandAll' else 'CollapseAll'

  # a flag to tell this is the top level block so it can have top level only components available
  $scope.isTopLevel = true

  $scope.block.blocks = contentService.getAll()

  # inherit from faberConfig if it is set when faber is initialised otherwise true by default
  $rootScope.expanded = if angular.isDefined faberConfig.expanded then faberConfig.expanded else true

  # initialise components service with the given components list
  componentsService.init(faberConfig.components or [])

  validateElementBlock = (block) ->
    if $scope.validateBlock block and block.blocks?.length > 0
      block.blocks = validateImported block.blocks
    return block

  validateGroupBlock = (block) ->
    if block.blocks?.length > 0
      for groupItem in block.blocks
        if groupItem.blocks?.length > 0
          groupItem.blocks = validateImported groupItem.blocks
    return block

  # validate the imported blocks at block level validation
  # at the block level validation, if the component set to the block is not found, the block will be removed trom the tree
  validateImported = (blocks) ->
    validated = []

    for block in blocks
      component = componentsService.findById block.component
      if component
        if component.type is 'element'
          validated.push validateElementBlock(block)
        if component.type is 'group'
          validated.push validateGroupBlock(block)
      else
        $log.warn 'cannot find a component with the given id': block.component

    return validated

  $scope.$on 'imported', (evt, blocks) ->
    $scope.block.blocks = validateImported blocks

