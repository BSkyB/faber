angular.module('faber').directive 'faberGroupItemBlock', () ->
  restrict: 'E'
  templateUrl: 'faber-group-item-block.html'
  controller: 'GroupItemBlockController'

  link: ($scope, $element, attrs, blockController)->
    $element[0].querySelector('.faber-group-item-title input').focus()