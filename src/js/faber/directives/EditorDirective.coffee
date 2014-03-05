faber.directive 'faberEditor', ()->
  scope: true
  restrict: 'AE'
  templateUrl: 'faber-editor.html'
  controller: 'EditorController'

  link: ($scope, $element, attrs)->