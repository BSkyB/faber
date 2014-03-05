# Services

## ContentService

Deals everything concerns the content blocks.

Always keep the data clean from all angular clutters.

*	`import` from JSON
*	`export` to JSON


## StorageService

Deals everything concerns saving the content blocks.

This service doesn't manipulate the actual data but simply put it in LocalStorage (or Session), or load the data from LocalStorage (or Session).

*	`save`
*	`load`


## ComponentsService

Manage plugged components + base components

* `import`
* `find` by types, template(id) and so on


## ThemesService

Manage plugged themes