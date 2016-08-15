# @cjsx React.DOM

React = require 'react'

SubjectMetadata = React.createClass
  displayName: "Metadata"

  getInitialState: ->
    metadata: null

  componentWillReceiveProps: (newProps) ->
    @updateMetadata(newProps.subject)

  componentDidMount: ->
    @updateMetadata(@props.subject)

  updateMetadata: (subject) ->
    $.get("/metadata/" + subject.meta_data["identifier"], (res) =>
      @setState metadata: res
    )

  render: ->
    if @state.metadata
      <div dangerouslySetInnerHTML={{__html: @state.metadata }}/>
    else
      <section></section>
module.exports = SubjectMetadata
