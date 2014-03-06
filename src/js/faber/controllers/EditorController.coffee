faber.controller 'EditorController', ($scope, contentService)->
  $scope.blocks = contentService.getAll()

  $scope.boundBlocks = contentService.getBlocks()

  $scope.$on 'imported', (evt, blocks)->
    $scope.blocks = blocks