React = require 'react'
{Navigation} = require 'react-router'
API = require 'lib/api'

module.exports = React.createClass
  displayName: "Browser"
  mixins: [Navigation]

  getInitialState: ->
    subjects: []

  render: ->
    <div>
        {
          for subject in @state.subjects
            <li key={subject.id}><img src={subject.location.standard} width="100"/></li>
        }
    </div>

  componentDidMount: ->
    @fetchSubjects()

  fetchSubjects: (params) ->

    _params = $.extend({
      browse: true
      limit: 10
    }, params)

    API.type('subjects').get(_params).then (subjects) =>
      @setState
        subjects: subjects

    if @fetchSubjectsCallback?
      @fetchSubjectsCallback()
