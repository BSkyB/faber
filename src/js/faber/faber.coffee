window.faber = angular.module('faber', [])
  .config ($sceProvider)->
      $sceProvider.enabled(false)
  .constant('faberConfig', {
      # (boolean) Default expanded flag for child blocks
      expanded: true

      # (array) List of components to be imported and managed by components service
      #
      # name:         (optional) the name to be displayed for the component
      # type:         (mandatory) either 'element' or 'group'
      #               element type can not have children but group type can
      # template:     (mandatory) path to the component's template. used as identifier as well
      # topLevelOnly: (optional) specify if the component block can only be used on the top level block
      #               and can not be a child of other block
      components: [
          new MediumEditorComponent()
      ]
    })
