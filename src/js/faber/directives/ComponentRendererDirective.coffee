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

    $scope.$watch 'component', ()->
      # retrieve the component's template and append it to the block
      if $scope.component and $scope.component.template
        componentTemplateUrl = $scope.component.template
        $http.get("#{componentTemplateUrl}", cache: $templateCache).success (data)->
          $component = $compile(data)($scope)
          $element.find('div').append $component

          $scope.component.init($element) if $scope.component.init
          $scope.renderer.select()

    $scope.$on 'SelectBlock', (evt, id)->
      unless id is $scope.$id
        $scope.renderer.unselect()