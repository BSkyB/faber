faber.controller 'EditorController', ($rootScope, $scope, $controller, contentService, componentsService, faberConfig)->
  $controller('BlockController', {$scope: $scope})

  $scope.block.blocks = contentService.getAll()
  $scope.expanded = faberConfig.expanded

  $scope.$broadcast if $scope.expanded then 'ExpandAll' else 'CollapseAll'

  componentsService.init(faberConfig.components or [])

  $scope.$on 'imported', (evt, blocks)->
    $scope.block.blocks = blocks
