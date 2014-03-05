faber.factory 'contentService', ($rootScope)->
  blocks = []

  clear: ()->
    blocks = []

  newBlock: (inputs, component, type)->
    'inputs': inputs
    'component': component
    'type': type

  validateBlock: (block)->
    angular.isObject(block.inputs) and angular.isString(block.component) and (block.type is 'element' or block.type is 'group')

  getAll: ()->
    blocks

  import: (json)->
    imported = angular.fromJson json

    if angular.isArray imported
      blocks = imported
      $rootScope.$broadcast 'imported', blocks
      return true
    else
      return false

  export: ()->
    json = angular.toJson blocks
    $rootScope.$broadcast 'exported', json
    return json