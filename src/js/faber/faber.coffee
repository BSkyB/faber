window.faber = angular.module('faber', ['templates'])
  .constant('faberConfig', {
      expanded: true
      components: [
          name: 'Top Level Only Group',
          type: 'group',
          template: '/js/components/samples/top-level-only-group.html'
          topLevelOnly: true
        ,
          name: 'Top Level Only Element',
          type: 'element',
          template: '/js/components/samples/top-level-only-element.html'
          topLevelOnly: true
        ,
          name: 'Group',
          type: 'group',
          template: '/js/components/samples/group.html'
        ,
          name: 'Element 1',
          type: 'element',
          template: '/js/components/samples/element1.html'
        ,
          name: 'Element 2',
          type: 'element',
          template: '/js/components/samples/element2.html'
      ]
    })
