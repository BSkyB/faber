class Element1
  name: 'Element 1',
  type: 'element',
  template: '/js/components/samples/element1.html'

  init: ($element)->
    $element.find('p').text('hello')

  selected: ($element)->
    $element.find('p').attr('contenteditable', true)
    $element.find('p').focus()

  unselected: ($element)->
    $element.find('p').removeAttr('contenteditable')