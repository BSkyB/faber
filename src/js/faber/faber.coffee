window.faber = angular.module('faber', ['templates'])
  .constant('faberConfig', {
      expanded: false
      components: [
          name: 'Top Level Only 1',
          type: 'element',
          template: '/js/components/samples/topLevelOnly1.html'
          topLevelOnly: true
        ,
          name: 'Top Level Only 2',
          type: 'element',
          template: '/js/components/samples/topLevelOnly2.html'
          topLevelOnly: true
        ,
          name: 'Comp 1',
          type: 'element',
          template: '/js/components/samples/comp1.html'
        ,
          name: 'Comp 2',
          type: 'element',
          template: '/js/components/samples/comp2.html'
        ,
          name: 'Comp 3',
          type: 'element',
          template: '/js/components/samples/comp3.html'
      ]
    })
