class FaberComponent
  name: ''
  type: 'group'
  template: ''
  topLevelOnly: false

  constructor: (opts = []) ->
    @name = opts.name or ''
    @type = opts.type or 'group'
    @template = opts.template or ''
    @topLevelOnly = opts.type is 'group' and (opts.topLevelOnly is true or opts.topLevelOnly is undefined)

  init: ($element)->

  selected: ($element)->

  unselected: ($element)->