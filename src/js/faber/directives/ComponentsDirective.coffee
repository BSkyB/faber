faber.directive 'faberComponents', () ->
  restrict: 'AE'
#  scope:
#    components: '=faberAvailableComponents'
  templateUrl: 'faber-components.html'

  link: ($scope, $element, attrs) ->

