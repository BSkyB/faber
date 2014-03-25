faber.directive 'trustHtml', ($sce)->
  replace: true
  restrict: 'M'
  template: '<div ng-bind-html="trustedHtml"></div>'

  link: ($scope, $element, attrs)->
    $scope.$watch attrs.trustHtml, (newValue, oldValue)->
      unless newValue? is oldValue
        $scope.trustedHtml = $sce.trustAsHtml newValue