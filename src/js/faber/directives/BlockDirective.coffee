faber.directive 'faberBlock', ($compile) ->
  scope:
    'block': '=faberBlockContent'
  restrict: 'AE'
  templateUrl: 'faber-block.html'
  controller: 'BlockController'

  compile: ($element, $attrs, transclude) ->
    contents = $element.contents().remove()
    compiledContents = null

    pre: ($scope, $element, $attrs) ->
      unless compiledContents
        compiledContents = $compile contents, transclude

      compiledContents $scope, (clone, $scope) ->
        $element.append clone
