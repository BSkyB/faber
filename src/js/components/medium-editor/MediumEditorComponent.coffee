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
  template: '<div class="medium-editor"></div>'

  init: ($element)->
    opts =
      buttons: ['bold', 'italic', 'underline', 'anchor', 'unorderedlist', 'orderedlist', 'header1', 'header2', 'header3', 'quote']
      placeholder: 'Type your text'

    new MediumEditorExtended $element[0].getElementsByClassName 'medium-editor', opts

  selected: ($element)->

  unselected: ($element)->
