angular.module('faber').directive 'faberBlockList', () ->
  restrict: 'E'
  scope:
    block: '=faberBlock'
    components: '=faberAvailableComponents'
    isExpanded: '=isExpanded'
  templateUrl: 'faber-block-list.html'
  controller: 'BlockListController'
