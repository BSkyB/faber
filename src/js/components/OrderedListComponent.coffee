class OrderedListComponent
  name: 'Ordered List'
  id: 'ordered-list'
  type: 'group'

  # For this sample component, angular directive ng-repeat is used
  # but DOM can be directly managed from init()
  # Check README to find out more about how to make components
  template: '<ol class="ordered-list">
    <li ng-repeat="b in block.blocks">
      <p>{{ b.title }}</p>
      <faber-render data-faber-render-block="b"/>
    </li>
  </ol>'

  init: ($scope, $element, content)->