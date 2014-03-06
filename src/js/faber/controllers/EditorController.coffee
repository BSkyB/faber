faber.controller 'EditorController', ($rootScope, $scope, contentService, faberConfig)->
  $scope.blocks = contentService.getAll()
  $scope.expanded = faberConfig.expanded

  $scope.$broadcast if $scope.expanded then 'ExpandAll' else 'CollapseAll'

  $scope.$on 'imported', (evt, blocks)->
    $scope.blocks = blocks
