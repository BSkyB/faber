faber.factory 'componentsService', ($filter, $log) ->
  # Initalise components collection.
  components = []

  # Validates the component is valid.
  #
  # @param [object] component to validate.
  # @return [Boolean] true when the component is valid.
  #
  validate = (component) ->
    (angular.isObject(component.inputs) or !component.inputs) and angular.isString(component.id) and (component.type is 'element' or component.type is 'group')

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

  # Find components by ID.
  #
  # @param [string] id the template id to filter by.
  # @return [Array<FaberComponent>] the matching components.
  #
  findById: (id) ->
    res = $filter('filter') components, id: id, true

    return if res.length > 0 then res[0] else null
