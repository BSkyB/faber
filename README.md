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

Faber has exposed the following services functions so they can be used outside of the module.


### faber.import(JSON)

```
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

Exposed import function of ContenService.

It takes a JSON format string as an argument and populate the blocks after validating it.


### faber.export()

Exposed export function of ContentService.

It will return JSON formatted blocks


## Faber configuration

The configuration can be done using `faberConfig` constant when faber is initialised.

```javascript
window.faber = angular.module('faber', []).constant('faberConfig', {
  expanded: true,
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

### components

> List of components to be imported and managed by components service.

Components typically have the following parameters

##### type (mandatory)

> Either `element` or `group`.

`element` type can not have children

`group` type can have children

##### template (mandatory)

> The component's template as a string.

##### name (optional)

> The name to be displayed for the component. Used as the identifier by components service.

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
