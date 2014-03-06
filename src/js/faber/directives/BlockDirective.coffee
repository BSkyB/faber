faber.directive 'faberBlock', ($templateCache)->
  scope: true
  restrict: 'AE'
  template: $templateCache.get 'faber-block.html'
  controller: 'BlockController'

  link: ($scope, $element, attrs)->
