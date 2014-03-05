faber.directive 'faberEditor', ()->
#  scope: true
  restrict: 'AE'
#  template: '<p>{{greeting}}</p>'
  templateUrl: 'faber-editor.html'
  controller: 'EditorController'

  link: ($scope, $element, attrs)->