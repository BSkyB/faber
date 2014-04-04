angular.module('faber').directive 'faberEditor', ($rootScope, $document, $timeout) ->
  restrict: 'AE'
  templateUrl: 'faber-editor.html'
  controller: 'EditorController'

  link: ($scope, $element, attrs)->
    $document[0].addEventListener 'click', (evt)->
      isInside = false
      el = evt.target

      while el and el.tagName and (el.tagName.toLowerCase() != 'body')
        if el is $element[0]
          isInside = true
          break
        else
          el = el.parentNode

      unless isInside
        $rootScope.$apply ()->
          $rootScope.$broadcast 'ShowComponents', null
          $rootScope.$broadcast 'SelectBlockOfIndex', null
    , true

    $scope.$on 'imported', (evt, blocks) ->
      # make sure to close all components menu
      $timeout ()->
        $rootScope.$broadcast 'ShowComponents', null


    $rootScope.$watch 'isExpanded', ()->
      $rootScope.$broadcast if $rootScope.isExpanded then 'ExpandAll' else 'CollapseAll'