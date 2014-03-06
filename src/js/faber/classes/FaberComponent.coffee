class FaberComponent
  constructor: (opts)->
    @name = opts.name or ''
    @template = opts.template or ''
    @type = opts.type or 'group'
    @nestable = opts.type is 'group' and (opts.nestable is true or opts.nestable is undefined)