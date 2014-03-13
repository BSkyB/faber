faber.directive 'faberComponentRenderer', ($http, $templateCache, $compile)->
  restrict: 'AE'

  link: ($scope, $element, attrs)->
    $scope.$watch 'component', ()->
      # retrieve the component's template and append it to the block
      if $scope.component and $scope.component.template
        componentTemplateUrl = $scope.component.template
        $http.get("#{componentTemplateUrl}", cache: $templateCache).success (data)->
          $element.append $compile(data)($scope)