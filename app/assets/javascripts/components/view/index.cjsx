React = require 'react'
{Navigation} = require 'react-router'
{Link} = require 'react-router'

ViewPanel = require './view-panel'


module.exports = React.createClass
  displayName: "View"
  mixins: [Navigation]

  render: ->
    <ViewPanel identifier={@props.params.identifier}  /> 
