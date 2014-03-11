faber.controller 'EditorController', ($rootScope, $scope, $controller, $log, contentService, componentsService, faberConfig)->
  $controller('BlockController', {$scope: $scope})

  $scope.block.blocks = contentService.getAll()
  $scope.expanded = faberConfig.expanded

  $scope.$broadcast if $scope.expanded then 'ExpandAll' else 'CollapseAll'

  componentsService.init(faberConfig.components or [])

  processElementBlock = (block)->
    if $scope.validateBlock block
      if block.blocks?.length > 0
        block.blocks = process block.blocks
    return block

  progessGroupBlock = (block)->
    if block.blocks?.length > 0
      for groupItem in block.blocks
        if groupItem.blocks?.length > 0
          groupItem.blocks = process groupItem.blocks
    return block

  process = (blocks)->
    processed = []

    for block in blocks
      component = componentsService.findByTemplate block.component
      if component
        if component.type is 'element'
          processed.push processElementBlock(block)
        if component.type is 'group'
          processed.push progessGroupBlock(block)
      else
        $log.warn 'cannot find a component of the given template': block.component

    return processed

  $scope.$on 'imported', (evt, blocks)->
    $scope.block.blocks = process blocks