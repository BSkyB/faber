window.faber = angular.module('faber', ['ngAnimate', 'ngCookies'])
  .constant('faberConfig', {
      # (boolean) Default expanded flag for child blocks
      expanded: true

      # (string) Prefix to be used when save the content to cookie
      prefix: 'faber'

      # (array) List of components to be imported and managed by components service
      components: [
#          new MediumEditorComponent()
          MediumEditorComponent
      ]
    })
  .run (contentService)->
    faber.import = contentService.import
    faber.export = contentService.export

    # Added only to make test easier
    faber.load = contentService.load