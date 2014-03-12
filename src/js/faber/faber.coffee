window.faber = angular.module('faber', ['templates'])
  .constant('faberConfig', {
      expanded: false
      components: [
          name: 'Top Level Only 1',
          type: 'element',
          template: 'topLevelOnly1.html'
          topLevelOnly: true
        ,
          name: 'Top Level Only 2',
          type: 'element',
          template: 'topLevelOnly2.html'
          topLevelOnly: true
        ,
          name: 'Comp 1',
          type: 'element',
          template: 'comp1.html'
        ,
          name: 'Comp 2',
          type: 'element',
          template: 'comp2.html'
        ,
          name: 'Comp 3',
          type: 'element',
          template: 'comp3.html'
      ]
    })
