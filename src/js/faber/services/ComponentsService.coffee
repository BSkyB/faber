faber.factory 'componentsService', ($filter, $log) ->
  # Initalise components collection.
  components = []

  # Validates the component is valid.
  #
  # @param [object] component to validate.
  # @return [Boolean] true when the component is valid.
  #
  validate = (component) ->
    (angular.isObject(component.inputs) or !component.inputs) and angular.isString(component.template) and (component.type is 'element' or component.type is 'group')

  # Initalizes the component service.
  #
  # @param [Array] list of components the faber will support.
  #
  init: (list) ->
    components = []
    for comp in list
      if validate comp
        components.push comp
      else
        $log.warn 'invalid': comp

  # Get all components.
  #
  # @return [Array<FaberComponent>] all of the available components.
  #
  getAll: ->
    components

  # Find components by their type.
  #
  # @param [string] type the type of component to filter on.
  # @return [Array<FaberComponent>] the filtered components.
  #
  findByType: (type) ->
    $filter('filter') components, type: type, true

  # Find top level only components.
  #
  # @return [Array<FaberComponent>] the top level components.
  #
  findTopLevelOnly: ->
    $filter('filter') components, topLevelOnly: true, true

  # Find non-top-level-only components.
  #
  # @return [Array<FaberComponent>] the top level components.
  #
  findNonTopLevelOnly: ->
    result = []
    for comp in components
      result.push(comp) unless comp.topLevelOnly
    return result

  # Find components by template.
  #
  # @param [string] template the template name to filter by.
  # @return [Array<FaberComponent>] the components with the supploed template.
  #
  findByTemplate: (template) ->
    res = $filter('filter') components, template: template, true

    return if res.length > 0 then res[0] else null
