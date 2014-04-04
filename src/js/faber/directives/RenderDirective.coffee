angular.module('faber').directive 'faberRender', ($compile, componentsService)->
  restrict: 'AE'
  templateUrl: 'faber-render.html'
  scope:
    data: '=faberRenderBlock'

  link: ($scope, $element, $attrs)->
    $scope.isGroupPreview = ()->
      true