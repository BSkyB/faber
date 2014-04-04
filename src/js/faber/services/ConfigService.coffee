angular.module('faber').factory 'configService', ($rootScope) ->
  config =
    # (boolean) Default expanded flag for child blocks
    expanded: true

    # (string) Prefix to be used when save the content to cookie
    prefix: 'faber'

    # (array) List of components to be imported and managed by components service
    components: [
      RichTextComponent
      OrderedListComponent
    ]

  faber.init = @init

  init: (newConfig)->
    angular.extend config, newConfig
    $rootScope.$broadcast 'ConfigUpdated', config


  get: ()->
    config
