faber.controller 'EditorController', ($rootScope, $scope, contentService, componentsService, faberConfig)->
  $scope.blocks = contentService.getAll()
  $scope.expanded = faberConfig.expanded

  $scope.$broadcast if $scope.expanded then 'ExpandAll' else 'CollapseAll'

  componentsService.init(faberConfig.components or [])

  $scope.$on 'imported', (evt, blocks)->
    $scope.blocks = blocks
