angular.module('faber').directive 'faberBlockList', () ->
  scope:
    'block': '=faberBlock'
    'components': '=faberAvailableComponents'
  restrict: 'E'
  templateUrl: 'faber-block-list.html'
  controller: 'BlockListController'

  link: ($scope, $element, attrs, blockController) ->
    console.log "Block list linked"
