angular.module('faber').controller 'EditorController', ($rootScope, $scope, $controller, $log, configService, contentService, componentsService) ->
  internalComponents = [
    GroupItemComponent
  ]

  injectComponents = (dest, src) ->
    # FIXME this is awful.
    # Can't be bothered to do it optimally on such a short list
    res = [].concat(dest)
    for cmp in src
      res.push(cmp) unless dest.indexOf(cmp) > -1

    res

  configEditor = (config)->
    $rootScope.isExpanded = if angular.isDefined config.expanded then config.expanded else true

    components = injectComponents (config.components or []), internalComponents
    componentsService.init components

    # retrieve available component list for the current block
    $scope.components = componentsService.getAll()

  # extends BlockController
  $controller('BlockController', {$scope: $scope})

  # a flag to tell this is the top level block so it can have top level only components available
  $scope.isTopLevel = true

  $scope.block.blocks = []
  contentService.init $scope.block

  configEditor configService.get()

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
    $scope.$apply ()->
      $scope.block.blocks = validateImported blocks

  $scope.$on 'ConfigUpdated', (evt, config)->
    configEditor config

  $rootScope.$on 'BlockUpdated', (evt)->
    angular.module('faber').fire 'BlockUpdated', angular.copy($scope.block.blocks)
