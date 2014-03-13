faber.factory 'contentService', ($rootScope) ->
  # Initialise blocks collection
  blocks = []

  # Clear out the existing blocks
  #
  # @return [Array] cleared and empty blocks
  clear: () ->
    blocks = []

  # Retrieve all the blocks
  #
  # @return [Array] all the blocks saved in the collection
  getAll: () ->
    blocks

  # Import and create blocks collection from the json and broadcast 'imported' event with the imported blocks
  #
  # @return [boolean] true if the import succeeds
  import: (json) ->
    imported = angular.fromJson json

    if angular.isArray imported
      blocks = imported
      $rootScope.$broadcast 'imported', blocks
      return true
    else
      return false

  # Export the blocks collection to json format
  #
  # @return [string] JSON format of the exported blocks
  export: () ->
    json = angular.toJson blocks
    $rootScope.$broadcast 'exported', json
    return json
