faber.directive 'faberEditor', ($rootScope, $document, $timeout) ->
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
          $rootScope.$broadcast 'SelectBlock', null
    , true

    $scope.$on 'imported', (evt, blocks) ->
      # make sure that no blocks are selected when they are bulk imported
      $timeout ()->
        $rootScope.$broadcast 'SelectBlock', null

    $rootScope.$watch 'expanded', ()->
      $rootScope.$broadcast if $rootScope.isExpanded then 'ExpandAll' else 'CollapseAll'