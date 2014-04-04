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
)