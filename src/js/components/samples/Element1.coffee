class Element1
  name: 'Element 1',
  type: 'element',
  template: '/js/components/samples/element1.html'

  init: ($scope, $element)->
    $element.find('input').focus()