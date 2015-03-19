angular.module('faber').directive 'faberBlockList', () ->
  restrict: 'E'
  scope:
    block: '=faberBlock'
    components: '=faberAvailableComponents'
  templateUrl: 'faber-block-list.html'
  controller: 'BlockListController'
