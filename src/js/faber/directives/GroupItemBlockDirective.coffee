faber.directive 'faberGroupItemBlock', () ->
  restrict: 'E'
  templateUrl: 'faber-group-item-block.html'
  controller: 'GroupItemBlockController'

  link: ($scope, $element, attrs, blockController)->
