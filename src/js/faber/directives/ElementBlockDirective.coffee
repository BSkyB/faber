faber.directive 'faberElementBlock', ($rootScope, $compile, $timeout) ->
#  scope:
#    'block': '=faberBlockContent'
  restrict: 'E'
#  transclude: true
  templateUrl: 'faber-element-block.html'
  controller: 'BlockController'