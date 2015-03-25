angular.module('faber').directive 'faberBlock', ($rootScope, $compile, $timeout) ->
  isEventTargetSelect = (evt)->
    return evt and evt.target and evt.target.tagName.toLowerCase() is 'select'

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

      $scope.isExpanded = !!$rootScope.isExpanded

      $scope.isSelected = false
      $scope.isMoving = false

      $scope.isPreview = false

      $scope.isGroupBlock = false
      $scope.isGroupItemBlock = false
      $scope.isElementBlock = false


      $scope.isMouseHover = false

      $scope.mouseOver = (evt)->
        $scope.isMouseHover = true

      $scope.mouseOut = (evt)->
        unless isEventTargetSelect(evt)
          $scope.isMouseHover = false

      # Get available index range that can be used to move in the parent block's children
      # Used to create the select options
      $scope.indexRange = ()->
        res = []
        min = 0
        max = if $scope.$parent and $scope.$parent.block and $scope.$parent.block.blocks then Math.max($scope.$parent.block.blocks.length-1, min) else min
        for i in [min..max]
          res.push i
        return res

      $scope.onSelectChange = ()->
        to = $element.find('select').val()
        if to >= 0
          $scope.moveSelf to

          # Setting isMoving to true is wrapped inside of $timeout so it can be applied after false is set first
          $rootScope.$broadcast 'ResetIsMoving'
          $timeout ()->
            $scope.isMoving = true

      $scope.onBlockClick = (evt)->
        evt.stopPropagation() if evt

        unless isEventTargetSelect(evt)
          $rootScope.$broadcast 'ShowComponents', null
          $rootScope.$broadcast 'SelectBlockOfIndex', $scope.$parent, $scope.$parent.block.blocks.indexOf($scope.block)

      # Select the block
      $scope.select = (evt)->
        $scope.isSelected = true

      # Unselect the block
      $scope.unselect = (evt)->
        $scope.isSelected = false

      # Emit RemoveChildBlock event with itself so its parent block can remove it
      $scope.removeSelf = ()->
        $scope.$parent.remove $scope.block

      # Edmit MoveChildBlock event with destination index so its parent block can move it to the new index
      $scope.moveSelf = (to)->
        $scope.$parent.move $scope.$parent.block.blocks.indexOf($scope.block), to

      # Switch to edit mode on group block
      $scope.edit = (evt)->
        evt.stopPropagation() if evt

        return unless $scope.isGroupBlock

        $scope.isPreview = false

        $rootScope.$broadcast 'ResetIsMoving'

      # Switch to preview mode on group block
      $scope.preview = (evt)->
        evt.stopPropagation() if evt

        return unless $scope.isGroupBlock

        $scope.isPreview = true

      # Expand group item block
      $scope.expand = (evt)->
        evt.stopPropagation() if evt

        return unless $scope.component.isCollapsible

        $scope.isExpanded = true

      # Collapse group item block
      $scope.collapse = (evt)->
        evt.stopPropagation() if evt

        return unless $scope.component.isCollapsible

        $scope.isExpanded = false

      $scope.$on 'ResetIsMoving', (evt)->
        $scope.isMoving = false

      $scope.$on 'SelectBlockOfIndex', (evt, scope, index)->
        unless scope
          $scope.unselect()
          return

        if scope.block.blocks[index] is $scope.block
          $scope.select()
        else
          $scope.unselect()

      $scope.$on 'PreviewAll', (evt)->
        $scope.preview()

      $scope.$on 'CollapseAll', (evt)->
        $scope.isExpanded = false

      $scope.$on 'ExpandAll', (evt)->
        $scope.isExpanded = true

      $scope.$watchCollection '[$parent.component, component]', ()->
        $scope.isElementBlock = $scope.isGroupBlock = false

        if $scope.component
          if $scope.component.type is 'element'
            $scope.isElementBlock = true
          if $scope.component.type is 'group'
            $scope.isGroupBlock = true
          if $scope.component.type is 'internal'
            $scope.isInternalBlock = true
