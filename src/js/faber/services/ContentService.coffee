faber.factory 'contentService', ()->
  blocks = []

  import: (json)->
    imported = angular.fromJson json

    if angular.isArray imported
      blocks = imported
      return true
    else
      return false

  export: ()->
    json = angular.toJson blocks