class Element1
  name: 'Element 1',
  id: 'element-1',
  type: 'element',
  template: '<span>[{{$id}}]</span><p contenteditable="contenteditable">Element 1</p>'

  init: ($element)->
    $element.find('p').text('hello')

  selected: ($element)->
    $element.find('p').attr('contenteditable', true)
    $element.find('p').focus()

  unselected: ($element)->
    $element.find('p').removeAttr('contenteditable')
