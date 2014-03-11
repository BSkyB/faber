# Controllers

## EditorController

Manage services.

*	Controller of EditorDirective
*	Manage the whole block list using the services and every block item in the list is bound to BlockController


## BlockController

Manage blocks and feedback to ContentService.

### Block object structure

```
{
	component: {} // component data retrieved using data.component
	data: {
		type: ('element'|'group'),
		component: '<component id/template>'
		blocks: [...] // children
	}
}
```

*	Controller of BlockDirective and data part will be fed from the directive.
*	Element type block wouldn't have children blocks
*	Keep data part clean so it can be directly fed back into ContentService to export.