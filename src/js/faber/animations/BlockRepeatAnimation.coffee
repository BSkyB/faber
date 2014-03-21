faber.animation '.faber-block-repeat', ($window, $document, $rootElement, $interval)->
  getEnd = (el)->
    pos = 0

    if el.offsetParent
      loop
        pos += el.offsetTop
        el = el.offsetParent
        break unless el

    return Math.max pos, 0

  move: ($element, done)->
    start = $window.pageYOffset
    end = getEnd($element[0]) - 40
    distance = end - start

    $interval.cancel $window.faberBlockRepeatAnimationWatch

    $window.faberBlockRepeatAnimationWatch = $interval ()->
      distance /= 2

      $window.scrollBy 0, distance

      if Math.abs(distance) <= 1
        $interval.cancel $window.faberBlockRepeatAnimationWatch

    , 50

    return null
    