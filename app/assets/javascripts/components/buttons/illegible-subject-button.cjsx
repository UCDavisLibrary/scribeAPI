React         = require 'react'
SmallButton   = require './small-button'

module.exports = React.createClass
  displayName: 'IllegibleSubjectButton'

  render: ->
    label = if @props.active then 'This text was marked illegible' else 'This text is illegible'
    if @props.label?
      label = @props.label
      
    <SmallButton key="illegible-subject-button" label={label} onClick={@props.onClick} className="secondary #{'toggled' if @props.active}" />
