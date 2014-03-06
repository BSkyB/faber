faber.directive 'faberBlock', ()->
  scope: true
  restrict: 'AE'
  template: 'faber-block.html'
  controller: 'BlockController'

  link: ($scope, $element, attrs)->
