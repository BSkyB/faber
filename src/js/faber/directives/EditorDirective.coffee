faber.directive 'faberEditor', ($rootScope, $rootElement) ->
  restrict: 'AE'
  templateUrl: 'faber-editor.html'
  controller: 'EditorController'

  link: ($scope, $element, attrs)->
    $rootElement[0].addEventListener 'click', (evt)->
      if $element.get(0) is evt.target
        evt.stopPropagation()
        $rootScope.$apply ()->
          $rootScope.$broadcast 'ShowComponents', null
          $rootScope.$broadcast 'SelectBlock', null
    , true