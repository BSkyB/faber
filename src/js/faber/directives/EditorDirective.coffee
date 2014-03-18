faber.directive 'faberEditor', ($rootScope, $rootElement) ->
  restrict: 'AE'
  templateUrl: 'faber-editor.html'
  controller: 'EditorController'

  link: ($scope, $element, attrs)->
    document.addEventListener 'click', (evt)->
      if  $element[0] is evt.target
        evt.stopPropagation()
        $rootScope.$apply ()->
          $rootScope.$broadcast 'ShowComponents', null
          $rootScope.$broadcast 'SelectBlock', null
    , true