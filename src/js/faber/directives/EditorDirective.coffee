faber.directive 'faberEditor', ($templateCache)->
  scope: true
  restrict: 'AE'
  template: $templateCache 'faber-editor.html'
  controller: 'EditorController'

  link: ($scope, $element, attrs)->
