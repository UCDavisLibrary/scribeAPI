# @cjsx React.DOM
React = require 'react'

TranscribeInput = React.createClass
  displayName: 'TranscribeInput'
  chooseOption: () ->
    value = @state.value # React.findDOMNode(@refs.textarea).value
    @props.chooseCallback(value)

  getInitialState: ->
    value: @props.value

  componentWillReceiveProps: (props) ->
    @setState value: props.value

  updateTextarea: (e) ->
    @setState value: e.target.value

  render: ->
      <div className="row align-middle">
        <div className="field-container small-8">
          <label htmFor="textarea">Transcription {@props.index + 1}:</label>
          <textarea rows="1" cols="48" onChange={@updateTextarea} ref="textarea" value={@state.value}></textarea>
        </div>
        <button type="button" className="button small-3" onClick={@chooseOption}>Accept</button>
      </div>

module.exports = TranscribeInput
