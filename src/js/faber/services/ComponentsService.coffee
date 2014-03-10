faber.factory 'componentsService', ($filter, $log)->
  components = []

  validate = (component)->
    (angular.isObject(component.inputs) or !component.inputs) and angular.isString(component.template) and (component.type is 'element' or component.type is 'group')

  init: (list)->
    components = []
    for comp in list
      if validate comp
        components.push comp
      else
        $log.warn 'invalid': comp

  getAll: ()->
    components

  findByType: (type)->
    $filter('filter') components, type: type, true

  findTopLevelOnly: ->
    $filter('filter') components, topLevelOnly: true, true

  findByTemplate: (template)->
    res = $filter('filter') components, template: template, true

    return if res.length > 0 then res[0] else null
