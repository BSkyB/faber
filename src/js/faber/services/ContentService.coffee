faber.factory 'contentService', ($rootScope, $cookieStore, faberConfig) ->
  # Initialise blocks collection
  content =
    blocks: []

  init: (initial)->
    content = initial

  # Clear out the existing blocks
  #
  # @return [Array] cleared and empty blocks
  clear: () ->
    content.blocks = []

  # Retrieve all the blocks
  #
  # @return [Array] all the blocks saved in the collection
  getAll: () ->
    content.blocks

  # Import and create blocks collection from the json and broadcast 'imported' event with the imported blocks
  #
  # @return [boolean] true if the import succeeds
  import: (json) ->
    imported = angular.fromJson json

    if angular.isArray imported
      content.blocks = imported
      $rootScope.$broadcast 'imported', content.blocks
      return true
    else
      return false

  # Export the blocks collection to json format
  #
  # @return [string] JSON format of the exported blocks
  export: () ->
    json = angular.toJson content.blocks
    $rootScope.$broadcast 'exported', json
    return json

  # Save the JSON formatted content to cookie using ngCookies
  save: ()->
    $cookieStore.put (faberConfig.prefix or 'faber') + '.data', content.blocks

  # Load and import the saved JSON format data from cookie using ngCookies
  load: ()->
    json = angular.toJson($cookieStore.get (faberConfig.prefix or 'faber') + '.data')
    @import(json)
    return json

  # Remove the saved JSON format data from cookie using ngCookies
  # It only removes the data related to the Faber instance using the prefix given
  removeSavedData: ()->
    $cookieStore.remove (faberConfig.prefix or 'faber') + '.data'
