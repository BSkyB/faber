faber.directive 'faberComponentRenderer', ($rootScope, $http, $templateCache, $compile, componentsService)->
  require: '^faberBlock'
  restrict: 'AE'
  scope:
    'block': '=faberComponentBlock'
  template: '<div ng-click="renderer.select($event)"></div>'

  link: ($scope, $element, attrs, blockController)->
    $scope.isSelected = false
    $scope.component = null

    $scope.select = (evt)->
      if evt
        evt.stopPropagation()

      $scope.component.selected($element, $scope.update) if $scope.component.selected
      $rootScope.$broadcast 'SelectBlock', $scope.$parent.$id

      $scope.isSelected = true

    $scope.unselect = ()->
      $scope.component.unselected($element, @update) if $scope.component.unselected
      $scope.isSelected = false

    $scope.update = (content)->
      if content
        $scope.block.content = content

    $scope.$watch 'block.component', ()->
      # retrieve the component's template and append it to the block
      $scope.component = componentsService.findById($scope.block.component)
      if $scope.block.component and $scope.component
        template = $scope.component.template
        $component = $compile(template)($scope)
        $element.find('div').append $component

        $scope.component.init($element, $scope.block.content, $scope.update) if $scope.component.init
        $scope.select()

    $scope.$on 'SelectBlock', (evt, id)->
      unless id is $scope.$parent.$id
        $scope.unselect()

