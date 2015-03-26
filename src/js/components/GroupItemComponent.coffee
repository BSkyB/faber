class GroupItemComponent
  name: 'Item'
  id: 'group-item'
  type: 'internal'
  isCollapsible: true

  template: '
<label class="faber-group-item-title">
  <input type="text" placeholder="Type the item\'s title" ng-model="block.title">
</label>
<faber-block-list ng-show="isExpanded"
                  data-is-expanded="isExpanded"
                  data-faber-block="block"
                  data-faber-available-components="components">'

  init: ($scope, $element, initialContent) ->
    componentsService = $element.injector().get('componentsService')

    $scope.components = componentsService.findByType 'element'
    $scope.block.blocks or= []
    delete $scope.block.content # don't need content on a group item
