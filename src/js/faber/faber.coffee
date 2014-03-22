window.faber = angular.module('faber', ['ngAnimate', 'ngCookies'])
#  .config ($sceProvider)->
#      $sceProvider.enabled(false)
  .constant('faberConfig', {
      # (boolean) Default expanded flag for child blocks
      expanded: true

      # (string) Prefix to be used when save the content to cookie
      prefix: 'faber'

      # (array) List of components to be imported and managed by components service
      #
      # name:         (optional) the name to be displayed for the component
      # id:           (mandatory) identifier of the component
      # type:         (mandatory) either 'element' or 'group'
      #               element type can not have children but group type can
      # template:     (mandatory) component's template as a string
      # topLevelOnly: (optional) specify if the component block can only be used on the top level block
      #               and can not be a child of other block
      components: [
          new MediumEditorComponent()
      ]
    })
  .run (contentService)->
    faber.import = contentService.import
    faber.export = contentService.export