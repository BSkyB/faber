Faber
=====

Block based content editor

## TODOs

1.	Pluggable themes
2.	Configurable Medium editor
3.	Setup publish task

## Usage

For use in the browser just use the files from `/dist`

## Development

Install dependencies and build

```
npm install -g gulp
npm install -g bower

npm install
gulp
```

Then start the live dev environment

```
gulp dev
```

This will run [Karma](http://karma-runner.github.io/) [Jasmine](http://jasmine.github.io/) unit test in the background while watching file changes

## Faber configuration

The configuration can be done using `faberConfig` constant when faber is initialised.

```javascript
window.faber = angular.module('faber', []).constant('faberConfig', {
  expanded: true,
  components: [
    {
      name: 'Top Level Only Group Component',
      type: 'group',
      template: '/js/components/samples/top-level-only-group.html',
      topLevelOnly: true,
      init: function($element) {
        //
      }
    }, {
      name: 'Top Level Only Element Component',
      type: 'element',
      template: '/js/components/samples/top-level-only-element.html',
      topLevelOnly: true
    }, {
      name: 'Group Component',
      type: 'group',
      template: '/js/components/samples/group.html',
      init: function($element) {
        //
      },
      selected: function($element) {
        //
      },
      unselected: function($element) {

      }
    }, {
      name: 'Element Component 1',
      type: 'element',
      template: '/js/components/samples/element1.html'
    }, {
      name: 'Element Component 2',
      type: 'element',
      template: '/js/components/samples/element2.html'
    }
  ]
});

```
### expanded

> Default 'expanded' flag for child blocks.

default: `true`

---

### components

> List of components to be imported and managed by components service.

##### type (mandatory)

> Either `element` or `group`.

`element` type can not have children

`group` type can have children

##### template (mandatory)

> Path to the component's template. Used as the identifier by components service.


##### name (optional)

> The name to be displayed for the component.

##### topLevelOnly (optional)

> Specifies if the component block can only be used on the top level block and can not be a child of other block.

default: `false`

##### init (optional)

> Callback function to be called when the component is rendered on the block list

`$element`: The rendered DOM element passed from ComponentRendererDirective

##### selected (optional)

> Callback function to be called when the rendered component block is selected

`$element`: The rendered DOM element passed from ComponentRendererDirective

##### unselected (optional)

> Callback function to be called when the rendered component block is unselected

`$element`: The rendered DOM element passed from ComponentRendererDirective
