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

class RichTextComponent
  name: 'Rich Text',
  id: 'rich-text',
  type: 'element',
  template: '<p>group preview: {{ $id }}, {{ isGroupPreview }}</p><div class="rich-text" data-tust-html><br/></div>'

  editor: null
  editorInstance: null

  init: ($scope, $element, initialContent, update)->
    opts =
      buttons: ['bold', 'italic', 'underline', 'anchor', 'unorderedlist', 'orderedlist', 'header1', 'header2', 'header3', 'quote']
      placeholder: 'Type your text'

    @editor = $element[0].getElementsByClassName('rich-text')[0]
    @editor.innerHTML = initialContent or ''

    @editorInstance = new MediumEditorExtended @editor, opts

    @editor.addEventListener 'input', ()=>
      update @editor.innerHTML

  selected: ($element, update)->
    @editorInstance.deactivate()
    @editorInstance.activate()
    $element[0].getElementsByClassName('rich-text')[0].focus()

  unselected: ($element, update)->
    $element[0].getElementsByClassName('rich-text')[0].blur()
    update @editor.innerHTML
