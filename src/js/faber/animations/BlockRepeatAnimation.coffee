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

    # Disable mouse hover effects so when the scroll finished, none of the blocks has :hover
    # Possibly increase animation performance as well
    $document.find('body').css 'pointer-events', 'none'

    $interval.cancel $window.faberBlockRepeatAnimationWatch

    $window.faberBlockRepeatAnimationWatch = $interval ()->
      distance /= 2

      $window.scrollBy 0, distance

      if Math.abs(distance) <= 1
        $interval.cancel $window.faberBlockRepeatAnimationWatch
        $document.find('body').css 'pointer-events', 'auto'

    , 50

    return null
    