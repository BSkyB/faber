Faber
=====

Block based content editor

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
window.faber = angular.module('faber', ['ngAnimate']).constant('faberConfig', {
  expanded: true,
  prefix: 'faber',
  components: [
    FaberComponent,
    MediumEditorComponent
  ]
});

```
### expanded

> Default 'expanded' flag for child blocks.

default: `true`

---

### prefix

> Prefix to be used when save the content to local storage

Default: 'faber'

---

### components

Check 'How to make a component' section for more details

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

## How to make a component

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


### With Angular

It is possible to use the passed down 'block' using Angular directives in the template


#### Element component
```javascript
var TextComponent = function() {
  return {
    name: 'Text',
    id: 'text',
    type: 'element',
    template: '<input type="text" ng-model="block.content"/>'
  };
};
```


#### Group component

```javascript
var OrderedListComponent = function() {
  return {
    name: 'Ordered List',
    id: 'ordered-list',
    type: 'group',
    template: '<ol class="ordered-list"><li ng-repeat="b in block.blocks">ordered list item</li></ol>'
  };
};
```


#### Using injector()

```javascript
var OrderedListComponent = function() {
  return {
    name: 'Ordered List',
    id: 'ordered-list',
    type: 'group',
    template: '<ol class="ordered-list"><li ng-repeat="b in block.blocks">ordered list item</li></ol>',

    init: function($element, content) {
      var injector = $element.injector();
      var $http = injector.get('$http');
      // ... do something with $http service
    }
  };
};
```


### Without Angular

Or build by manipulating DOM using your choice of tool sush as jQuery.

Initial content is passed to the component when `init()` is called and this is bound directly to block data.

Use `update()` to update the content if you want to control the timing of updating the content.
`update()` can have array, object, string or any type as the argument.


#### Element component

```javascript
var TextComponent = function() {
  return {
    name: 'Text',
    id: 'text',
    type: 'element',
    template: '<input class="text-component" type="text"/>',

    input: null

    init: function($element, initialContent, update) {

      this.input = $element[0].getElementsByClassName('text-component')[0]
      this.input.innerHTML = initialContent || '';

      var self = this;
      this.input.addEventListener('keyup', function() {
        update(self.input.innerHTML);
      });
    },

    selected: function($element, update) {
      // set focus the input field
      $element[0].getElementsByClassName('text-component')[0].focus()
    },

    unselected: function($element, update) {
      $element[0].getElementsByClassName('text-component')[0].blur()
      update(this.input.innerHTML);
    }
  };
};
```

#### Group component

`init()` will be called whenever it's switched to preview mode

Unlike element components, group components don't need selected and unlelected callback as they are always either preview or edit mode
and update callback is not passed with init() because of the same reason

```javascript
var OrderedListComponent = function() {
  return {
    name: 'Ordered List',
    id: 'ordered-list',
    type: 'group',
    template: '<ol class="ordered-list"></ol>',

    init: function($element, content) {
      // ... do something
    }
  };
};
```


## TODOs

1.	Pluggable themes
