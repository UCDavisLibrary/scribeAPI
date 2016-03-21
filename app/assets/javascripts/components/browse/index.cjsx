React = require 'react'
{Navigation} = require 'react-router'
{Link} = require 'react-router'
API = require 'lib/api'
GenericButton = require 'components/buttons/generic-button'
FetchSubjectsMixin = require 'lib/fetch-subjects-mixin'

module.exports = React.createClass
  displayName: "Browse"
  mixins: [Navigation, FetchSubjectsMixin]

  getDefaultProps: ->
    page: 1
    browse: true
    limit: 40
    type: "root"
        
  getInitialState: ->
    subjects: []

  render: ->
    if @state.subjects_prev_page?
       prevButton = <GenericButton onClick={@prevPage} label="Prev" />
    else
       prevButton = <span/>
    if @state.subjects_next_page?
       nextButton = <GenericButton onClick={@nextPage} label="Next" />
    else
       nextButton = <span/>

    <div className="temp-browse">
      <div className="temp-browse-nav">
        {prevButton}
        {nextButton}
      </div>
      <div className="groups">
          { 
            for subject in @state.subjects
              <div className="group" key={subject.id}>
                <Link to="/view/index/#{subject.order}">
                  <img src={subject.location.thumbnail} width="200" height="150"/>
                </Link>
              </div>
          }
      </div>
      <div className="temp-browse-nav">
        {prevButton}
        {nextButton}
      </div>              
      <div>Number of results: {@state.subjects_total_results}</div>
      <div>Current page: {@state.subjects_current_page}</div>                
   </div>
           
  nextPage: ->
    params =
      page: @state.subjects_next_page
      type: @props.type 
      limit: @props.limit
      browse: true
      
    @fetchSubjects(params)

  prevPage: ->
    params =
      page: @state.subjects_prev_page
      type: @props.type 
      limit: @props.limit
      browse: true
      
    @fetchSubjects(params)

