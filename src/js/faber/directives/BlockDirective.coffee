faber.directive 'faberBlock', ($rootScope, $compile, $timeout) ->
  scope:
    'block': '=faberBlockContent'
  restrict: 'E'
  templateUrl: 'faber-block.html'
  controller: 'BlockController'

  compile: ($element, $attrs, transclude) ->
    # remove nested <faber-block/> and compile it separately to prevent infinite loop
    contents = $element.contents().remove()
    compiledContents = null

    pre: ($scope, $element, $attrs) ->
      unless compiledContents
        compiledContents = $compile contents, transclude

      compiledContents $scope, (clone, $scope) ->
        $element.append clone

    post: ($scope, $element, $attrs) ->
      $scope.currentIndex = $scope.$parent.$index

      # Get available index range that can be used to move in the parent block's children
      # Used to create the select options
      $scope.indexRange = ()->
        res = []
        min = 0
        max = if $scope.$parent and $scope.$parent.block then Math.max($scope.$parent.block.blocks.length-1, min) else min
        for i in [min..max]
          res.push i
        return res

      $scope.onSelectChange = ()->
        to = $element.find('select').val()
        if to >= 0
          $rootScope.$broadcast 'SelectBlock', null

          $scope.moveSelf to

          # Setting isMoving to true is wrapped inside of $timeout so it can be applied after false is set first
          $scope.isMoving = false
          $timeout ()->
            $scope.isMoving = true
