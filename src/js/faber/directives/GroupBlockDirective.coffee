faber.directive 'faberGroupBlock', ($rootScope, $compile, $timeout) ->
#  scope:
#    'block': '=faberBlockContent'
  restrict: 'E'
#  transclude: true
  templateUrl: 'faber-group-block.html'
  controller: 'GroupBlockController'