class FaberComponent
  id: ''
  name: ''
  type: 'group'
  template: ''
  topLevelOnly: false

  constructor: (opts = []) ->
    @id = opts.id or ''
    @name = opts.name or ''
    @type = opts.type or 'group'
    @template = opts.template or ''
    @topLevelOnly = opts.type is 'group' and (opts.topLevelOnly is true or opts.topLevelOnly is undefined)

  init: ($element, update)->

  selected: ($element)->

  unselected: ($element)->
