faber.directive 'faberComponentRenderer', ($rootScope, $http, $templateCache, $compile, $sce)->
  require: '^faberBlock'
  restrict: 'AE'
  template: '<div ng-click="renderer.select($event)"></div>'

  link: ($scope, $element, attrs)->
    $scope.renderer =
      isSelected: false

      select: (evt)->
        if evt
          evt.stopPropagation()

        $scope.component.selected($element) if $scope.component.selected
        $rootScope.$broadcast 'SelectBlock', $scope.$id

        @isSelected = true

      unselect: ()->
        $scope.component.unselected($element) if $scope.component.unselected
        @isSelected = false

      update: (content)->
        $scope.block.content = content

    $scope.$watch 'component', ()->
      # retrieve the component's template and append it to the block
      if $scope.component and $scope.component.template
        template = $scope.component.template
        $component = $compile(template)($scope)
        $element.find('div').append $component

        $scope.component.init($element, $scope.block.content or '', $scope.renderer.update) if $scope.component.init
        $scope.renderer.select()

    $scope.$on 'SelectBlock', (evt, id)->
      unless id is $scope.$id
        $scope.renderer.unselect()

