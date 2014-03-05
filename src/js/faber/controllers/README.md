# Controllers

## EditorController

Manage services


## BlockController

Manage blocks and feedback to ContentService

### Block object structure

```
{
	type: ('element'|'group'),
	component: '<component id/template>'
	blocks: [] // children
			   // element type block wouldn't have children blocks
}
```
