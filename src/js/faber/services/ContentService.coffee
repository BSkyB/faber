faber.factory 'contentService', ($rootScope)->
  blocks = []

  clear: ()->
    blocks = []

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