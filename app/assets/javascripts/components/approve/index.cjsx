React = require 'react'

{Navigation} = require 'react-router'
{Link} = require 'react-router'
ViewPanel = require '../view/view-panel'

module.exports = React.createClass
  displayName: "Approve"
  mixins: [Navigation]
  render: ->
    <ViewPanel identifier={@props.params.identifier} showMarks={true} />
