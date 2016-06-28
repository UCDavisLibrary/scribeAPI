React           = require 'react'
API = require 'lib/api'

module.exports = React.createClass
  displayName: 'LabelTool'

  getInitialState: ->
    userText: null

  componentDidMount: ->
    # Get this mark's text content
    request = API.type("subjects").get @props.mark.subject_id
    request.then (subject) =>
      text = subject.child_subjects[0]?.data.values[0]?.value
      @setState
        userText: text

  render: ->
    return <div className="approve-overlay" id={'label-' + @props.mark.subject_id}>
      <span>{@state.userText}</span>
    </div>
