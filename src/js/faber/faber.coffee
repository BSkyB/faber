# Extend faber module to add initial init() because the module's run() is excuted later before the init() is needed
window.faber = angular.extend(
    angular.module('faber', ['ngAnimate'])
    .value('faberConfig', {})
    .run (configService, contentService)->
        faber.import = contentService.import
        faber.export = contentService.export

        faber.init = configService.init
        faber.init faber.initialConfig
  ,
    init: (config)->
      @initialConfig = config

    listen: (type, method, scope, context)->
      if !(listeners = this.listeners)
        listeners = this.listeners = {}

      if !(handlers = listeners[type])
       handlers = listeners[type] = []

      scope = (scope ? scope : window)

      handlers.push
        method: method
        scope: scope
        context: (context ? context : scope)

    stopListening: (type, handler)->
      if !(listeners = this.listeners)
        return

      if !(handlers = listeners[type])
        return

      handlers.splice handlers.indexOf(handler), 1

    fire: (type, data, context)->
      if !(listeners = this.listeners)
        return

      if !(handlers = listeners[type])
        return

      for handler in handlers
        if (typeof(context) is not "undefined") and (context is not handler.context)
          continue
        if (handler.method.call(type, data) is false)
          return false

      return true
)
