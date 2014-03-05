faber.controller 'EditorController', ($scope, contentService)->
  $scope.blocks = contentService.getAll()

  $scope.$on 'imported', (evt, blocks)->
    $scope.blocks = blocks