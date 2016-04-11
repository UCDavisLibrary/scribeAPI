React         = require 'react'
GenericButton = require './generic-button'

module.exports = React.createClass
  displayName: 'SmallButton'

  getDefaultProps: ->
    label: 'Next &gt;'
    className: ''
    
  render: ->

    <GenericButton {...@props} className={@props.className} />
     
