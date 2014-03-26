faber.factory 'componentsService', ($filter, $log) ->
  # Initalise components collection.
  raws = []

  # Validates the component is valid.
  #
  # @param [object] component to validate.
  # @return [Boolean] true when the component is valid.
  #
  validate = (component) ->
    comp = new component()
    (angular.isObject(comp.inputs) or !comp.inputs) and angular.isString(comp.id) and (comp.type is 'element' or comp.type is 'group')

  # Initalizes the component service.
  #
  # @param [Array] list of components the faber will support.
  #
  init: (list) ->
    raws = []
    for comp in list
      if validate comp
        raws.push comp
      else
        $log.warn 'invalid': comp

  # Get all components.
  #
  # @return [Array<FaberComponent>] all of the available components.
  #
  getAll: ->
    res = []
    for comp in raws
      res.push(new comp())

    return res

  # Find components by their type.
  #
  # @param [string] type the type of component to filter on.
  # @return [Array<FaberComponent>] the filtered components.
  #
  findByType: (type) ->
    $filter('filter') @getAll(), type: type, true

  # Find top level only components.
  #
  # @return [Array<FaberComponent>] the top level components.
  #
  findTopLevelOnly: ->
    $filter('filter') @getAll(), topLevelOnly: true, true

  # Find non-top-level-only components.
  #
  # @return [Array<FaberComponent>] the top level components.
  #
  findNonTopLevelOnly: ->
    result = []
    for comp in @getAll()
      result.push(comp) unless comp.topLevelOnly
    return result

  # Find components by ID.
  #
  # @param [string] id the template id to filter by.
  # @return [Array<FaberComponent>] the matching components.
  #
  findById: (id) ->
    unless id
      return null

    all = @getAll()
    res = $filter('filter') all, id: id, true

    return if res.length > 0 then res[0] else null
