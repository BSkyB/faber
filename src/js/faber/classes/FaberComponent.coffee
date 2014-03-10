class FaberComponent
  constructor: (opts = [])->
    @name = opts.name or ''
    @template = opts.template or ''
    @type = opts.type or 'group'
    @topLevelOnly = opts.type is 'group' and (opts.topLevelOnly is true or opts.topLevelOnly is undefined)