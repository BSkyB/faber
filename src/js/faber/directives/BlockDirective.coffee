faber.directive 'faberBlock', ()->
  scope: true
  restrict: 'AE'
  templateUrl: 'faber-block.html'
  controller: 'BlockController'

  link: ($scope, $element, attrs)->