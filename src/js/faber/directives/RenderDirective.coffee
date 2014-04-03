faber.directive 'faberRender', ($compile, componentsService)->
#  require: 'ngModel'
  restrict: 'AE'
  templateUrl: 'faber-render.html'
  scope:
    data: '=faberRenderBlock'

  link: ($scope, $element, $attrs)->
    $scope.isGroupPreview = ()->
      true