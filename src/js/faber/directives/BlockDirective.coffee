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

    post: ($scope, $element, $attrs, $ctrl) ->
      $scope.currentIndex = $scope.$parent.$index

      $scope.expanded = !!$rootScope.expanded

      $scope.isSelected = false
      $scope.isMoving = false

      $scope.mouseenter = ()->
        $scope.isMouseHover = true

      $scope.mouseleave = ()->
        $scope.isMouseHover = false

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

      $scope.onBlockClick = ()->
        $rootScope.$broadcast 'SelectBlock', $scope.$id

      # Select the block
      $scope.select = (evt)->
        if evt
          evt.stopPropagation()

        $scope.isSelected = true

      # Unselect the block
      $scope.unselect = (evt)->
        if evt
          evt.stopPropagation()

        $scope.isSelected = false

      # Emit RemoveChildBlock event with itself so its parent block can remove it
      $scope.removeSelf = ()->
        $scope.$parent.remove $scope.block

      # Edmit MoveChildBlock event with destination index so its parent block can move it to the new index
      $scope.moveSelf = (to)->
        $scope.$parent.move $scope.$parent.block.blocks.indexOf($scope.block), to

      $scope.$on 'SelectBlock', (evt, id)->
        $scope.isMoving = false

        if id is $scope.$id
          $scope.select()
        else
          $scope.unselect()

      $scope.$on 'CollapseAll', (evt)->
        $scope.expanded = false

      $scope.$on 'ExpandAll', (evt)->
        $scope.expanded = true

      $ctrl.select = ()->
        $scope.select()

      $ctrl.getScopeId = ()->
        $scope.$id

      $ctrl.getComponent = ()->
        $scope.component