React         = require 'react'
GenericButton = require './generic-button'

module.exports = React.createClass
  displayName: 'NextButton'

  getDefaultProps: ->
    label: 'Next'
 
  render: ->
    <GenericButton key="next-button" {...@props} className='next'/>
     
