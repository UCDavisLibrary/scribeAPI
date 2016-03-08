React = require 'react'
{Navigation} = require 'react-router'
{Link} = require 'react-router'
API = require 'lib/api'
GenericButton = require 'components/buttons/generic-button'
FetchSubjectsMixin = require 'lib/fetch-subjects-mixin'

module.exports = React.createClass
  displayName: "View"
  mixins: [Navigation, FetchSubjectsMixin]

  getDefaultProps: ->
    page: 1
    browse: true
    limit: 1
        
  getInitialState: ->
    subjects: []
    
  render: ->
    if @state.subjects[0]?.order > 1
       prevButton = <GenericButton onClick={@prevPage} label="Prev" />
    else
       prevButton = <span/>

    nextButton = <GenericButton onClick={@nextPage} label="Next" />

    <div className="temp-browse">
      <div className="temp-browse-nav">
        {prevButton}
        {nextButton}
      </div>
      { 
        for subject in @state.subjects
          <div className="temp-view" key={subject.id}><img src={subject.location.standard} width="1024" height="682" /></div>
      }
      <div className="temp-browse-nav">
        {prevButton}
        {nextButton}
      </div>              
      <div>Number of results: {@state.subjects_total_results}</div>
      <div>Current page: {@state.subjects_current_page}</div>                
   </div>
           
  nextPage: ->
    @fetchSubjects(order_filter: @state.subjects[0]?.order, limit: @props.limit, order_dir: "next")

  prevPage: ->
    @fetchSubjects(order_filter: @state.subjects[0]?.order - 1, limit: @props.limit, order_dir: "prev")

