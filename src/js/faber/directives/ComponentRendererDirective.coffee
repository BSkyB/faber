faber.directive 'faberComponentRenderer', ($http, $templateCache, $compile)->
  restrict: 'AE'

  link: ($scope, $element, attrs)->
    $scope.$watch 'component', ()->
      if $scope.component and $scope.component.template
        componentTemplateUrl = $scope.component.template
        $http.get("#{componentTemplateUrl}", cache: $templateCache).success (data)->
          $element.append $compile(data)($scope)