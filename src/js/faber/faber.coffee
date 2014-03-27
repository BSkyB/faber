window.faber = angular.module('faber', ['ngAnimate'])
  .constant('faberConfig', {
    # (boolean) Default expanded flag for child blocks
    expanded: true

    # (string) Prefix to be used when save the content to cookie
    prefix: 'faber'

    # (array) List of components to be imported and managed by components service
    components: [
      RichTextComponent
    ,
      ()->
        name: 'Element Component'
        id: 'element-component'
        type: 'element'
        template: '<p>element component</p>'
    ,
      OrderedListComponent
    ,
      ()->
        name: 'Group Component'
        id: 'group-component'
        type: 'group'
        template: '<ul><li>group component iten</li></ul>'
    ]
  })
  .run (contentService)->
    faber.import = contentService.import
    faber.export = contentService.export

    faber.load = contentService.load
    faber.removeSavedData = contentService.removeSavedData