React = require 'react'
{Navigation} = require 'react-router'
API = require 'lib/api'
GenericButton = require 'components/buttons/generic-button'

module.exports = React.createClass
  displayName: "Browse"
  mixins: [Navigation]

  getDefaultProps: ->
    page: 1
    
  getInitialState: ->
    subjects: []
    
  render: ->
    if @state.prevPage?
       prevButton = <GenericButton onClick={@prevPage} label="Prev" />
    else
       prevButton = <span/>
    if @state.nextPage?
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
              <div className="group" key={subject.id}><img src={subject.location.thumbnail} width="150" height="100"/></div>
          }
      </div>
      <div className="temp-browse-nav">
        {prevButton}
        {nextButton}
      </div>              
      <div>Number of results: {@state.totalResults}</div>
      <div>Current page: {@state.currentPage}</div>                
   </div>
           
  componentDidMount: ->
    @fetchSubjects()

  nextPage: (callback_fn)->
    @fetchSubjects(page: @state.nextPage)

  prevPage: (callback_fn) ->
    @fetchSubjects(page: @state.prevPage)
  
  fetchSubjects: (params) ->

    _params = $.extend({
      browse: true
      limit: 20
    }, params)

    API.type('subjects').get(_params).then (subjects) =>
      @setState
        subjects: subjects
        totalResults: subjects[0].getMeta('total_pages')
        nextPage: subjects[0].getMeta('next_page')
        prevPage: subjects[0].getMeta('prev_page')        
        currentPage: subjects[0].getMeta('current_page')
        
    if @fetchSubjectsCallback?
      @fetchSubjectsCallback()
