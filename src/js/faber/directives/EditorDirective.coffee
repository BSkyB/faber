faber.directive 'faberEditor', ()->
  scope: true
  restrict: 'AE'
  template: 'faber-editor.html'
  controller: 'EditorController'

  link: ($scope, $element, attrs)->
