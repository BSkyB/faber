Faber
=====

Block based content editor

## TODOs

1.	Pluggable themes

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

## Faber Services

Faber has exposed the following services so they can be used outside of the module.


### faber.import(JSON)

```javascript
var json = '[
  {
    "content": "content data for the first component-a block",
    "component": "component-a"
  },
  {
    "content": "content data for the second component-a block",
    "component": "component-a"
  },
  {
    "content": "content data for the component-b block",
    "component": "component-b"
  }
]';
faber.import(json);
```

> Exposed `import` function of ContenService.

> It takes a JSON format string as an argument and populate the blocks after validating it.


### faber.export()

> Exposed `export` function of ContentService.

> It will return JSON formatted blocks


## Faber configuration

The configuration can be done using `faberConfig` constant when faber is initialised.

```javascript
window.faber = angular.module('faber', []).constant('faberConfig', {
  expanded: true,
  prefix: 'faber',
  components: [
    new FaberComponent(),
    new MediumEditorComponent()
  ]
});

```
### expanded

> Default 'expanded' flag for child blocks.

default: `true`

---

### prefix

> Prefix to be used when save the content to cookie

Default: 'faber'

---

### components

> List of components to be imported and managed by components service.

``` javascript
var FaberComponent = function() {
  return {
    id: '',
    name: '',
    type: 'group',
    template: '<div></div>',
    topLevelOnly: false,

    init: function($element, update) {
      // Initialise the component
    },

    selected: function($element) {
      // Do something when the component block is selected
    },

    unselected: function($element) {
      // Do something when the component block is unselected
    },
  }
}
```

Components typically have the following parameters

##### type

> Mandatory

> Either `element` or `group`.

`element` type can not have children

`group` type can have children

##### template

> Mandatory

> The component's template as a string.

##### name

> Optional

> The name to be displayed for the component. Used as the identifier by components service.

##### topLevelOnly

> Optional

> Specifies if the component block can only be used on the top level block and can not be a child of other block.

Default: `false`

##### init($element, initialContent)

> Optional

> Callback function to be called when the component is rendered on the block list

`$element`: The rendered DOM element passed from ComponentRendererDirective

`initialContent`: Usually content passed to the block when Faber imported block data.
The format depends on how the component pass its data to `update` when it saves it.
For example, MediumEditorComponent sends a string of html format.

`update`: To be called whenever the component wants to update and save the content changes

##### selected ($element, update)

> Optional

> Callback function to be called when the rendered component block is selected

`$element`: The rendered DOM element passed from ComponentRendererDirective

`update`: To be called whenever the component wants to update and save the content changes

##### unselected ($element, update)

> Optional

> Callback function to be called when the rendered component block is unselected

`$element`: The rendered DOM element passed from ComponentRendererDirective

`update`: To be called whenever the component wants to update and save the content changes
