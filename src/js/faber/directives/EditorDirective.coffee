faber.directive 'faberEditor', ($rootScope, $document) ->
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