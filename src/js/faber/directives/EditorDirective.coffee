faber.directive 'faberEditor', ($rootScope, $document) ->
  restrict: 'AE'
  templateUrl: 'faber-editor.html'
  controller: 'EditorController'

  link: ($scope, $element, attrs)->
    $document[0].addEventListener 'click', (evt)->
#      console.log  $document.find('body')[0], $element[0], evt.target, evt

      isInside = false
      el = evt.target

      while el and el.tagName and (el.tagName.toLowerCase() != 'body')
        if el is $element[0]
          isInside = true
          break
        else
          el = el.parentNode

      unless isInside
        evt.stopPropagation()
        $rootScope.$apply ()->
          $rootScope.$broadcast 'ShowComponents', null
          $rootScope.$broadcast 'SelectBlock', null
    , true