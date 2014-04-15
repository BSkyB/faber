angular.module('faber').directive 'faberElementBlock', ($rootScope, $compile, $timeout) ->
  restrict: 'E'
  templateUrl: 'faber-element-block.html'
  controller: 'ElementBlockController'