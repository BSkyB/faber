faber.animation '.faber-block-repeat', ($window, $document, $rootElement, $interval)->
  getEnd = (el)->
    pos = 0

    if el.offsetParent
      loop
        pos += el.offsetTop
        el = el.offsetParent
        break unless el

    return Math.max pos, 0

  enter: ($element, done)->
    return null

  leave: ($element, done)->
    return null

  move: ($element, done)->
    start = $window.pageYOffset
    end = getEnd $element[0]
    distance = end - start

    # Remove the classes first and add again so it activates the transition again after it already moved once
#    $element.removeClass 'faber-block-repeat-moving-prep'
#    $element.removeClass 'faber-block-repeat-moving'

#    $element.addClass 'faber-block-repeat-moving-prep'

    $interval.cancel $window.faberBlockRepeatAnimationWatch

    $window.faberBlockRepeatAnimationWatch = $interval ()->
      distance /= 2

      $window.scrollBy 0, distance

      if Math.abs(distance) <= 1
        $interval.cancel $window.faberBlockRepeatAnimationWatch
#        $element.addClass 'faber-block-repeat-moving'

    , 50

    return null

  beforeAddClass: ($element, className, done)->
    return null

  addClass: ($element, className, done)->
    return null

  beforeRemoveClass: ($element, className, done)->
    return null

  removeClass: ($element, className, done)->
    return null
