class MediumEditorExtended extends MediumEditor
  constructor: (elements, options)->
    @defaults.firstHeader = 'h1'
    @defaults.secondHeader = 'h2'

    @init(elements, options)

  init: (elements, options)->
    super(elements, options)

  buttonTemplate: (btnType)->
    buttonTemplates =
      'header3': '<li><button class="medium-editor-action medium-editor-action-header3" data-action="append-h3" data-element="h3">H3</button></li>'

    super(btnType) or buttonTemplates[btnType]

class MediumEditorComponent
  name: 'Medium Editor',
  id: 'medium-editor',
  type: 'element',
  template: '<div class="medium-editor" data-tust-html><br/></div>'

  init: ($element, contentModel, update)->
    opts =
      buttons: ['bold', 'italic', 'underline', 'anchor', 'unorderedlist', 'orderedlist', 'header1', 'header2', 'header3', 'quote']
      placeholder: 'Type your text'

    editor = $element[0].getElementsByClassName('medium-editor')[0]
    editor.innerHTML = contentModel or ''

    new MediumEditorExtended editor, opts

    editor.addEventListener 'keyup', ()->
      update editor.innerHTML

  selected: ($element)->
    $element[0].getElementsByClassName('medium-editor')[0].focus()

  unselected: ($element)->
