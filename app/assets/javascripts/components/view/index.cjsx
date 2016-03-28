React = require 'react'
{Navigation} = require 'react-router'
{Link} = require 'react-router'
API = require 'lib/api'

ViewPanel = require './view-panel'


module.exports = React.createClass
  displayName: "View"
  mixins: [Navigation]

  render: ->
    <ViewPanel project={@props.project}  order_filter={@props.params.order_filter} subject_id={@props.params.subject_id} /> 

