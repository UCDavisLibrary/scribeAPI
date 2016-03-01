React         = require("react")
GenericButton    = require './buttons/generic-button'

module.exports = React.createClass
  displayName : "BrowserWarning"

  getInitialState: ->
    showing: ! @browserAcceptable()
    isTouchDevice: @isTouchDevice()

  browserAcceptable: ->
    pass = true
    # Need some kind of flexbox support:
    pass &&= Modernizr.flexbox
    # Need promises to work (note this may punish IE users even though we've shimmed it):
    pass &&= Modernizr.promises

    # Should warn about touch devices.
    pass &&= ! @isTouchDevice()

    pass

  isTouchDevice: ->
    # It's not enough to test Modernizr.touchevents
    # because many browsers implement touch events regardless of hardware
    deviceAgent = navigator.userAgent.toLowerCase()
    ret = (
      deviceAgent.match(/(iphone|ipod|ipad)/) ||
      deviceAgent.match(/(android)/)  ||
      deviceAgent.match(/(iemobile)/) ||
      deviceAgent.match(/iphone/i) ||
      deviceAgent.match(/ipad/i) ||
      deviceAgent.match(/ipod/i) ||
      deviceAgent.match(/blackberry/i) ||
      deviceAgent.match(/bada/i)
    )
    ret

  close: ->
    @setState showing: false

  render:->
    return null if ! @state.showing
