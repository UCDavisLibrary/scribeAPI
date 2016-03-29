React = require 'react'
{Navigation} = require 'react-router'
{Link} = require 'react-router'
API = require 'lib/api'
FetchSubjectsMixin = require 'lib/fetch-subjects-mixin'

module.exports = React.createClass
  displayName: "ViewPanel"
  mixins: [Navigation, FetchSubjectsMixin]

  getDefaultProps: ->
    identifier: null

  getInitialState: ->
    subjects: []
    subjects_next_page: null
    subjects_prev_page: null

  componentWillReceiveProps: (newProps) ->
    if @props.identifier != newProps.identifier
      @fetchSubjectByIdentifier newProps.identifier
    
  render: ->
    subject = @state.subjects?[0]
      
    if @state.subjects_prev_page
      prevButton = <Link className="button" to={@state.subjects_prev_page}>Previous Label</Link>
    else
      prevButton = <span/>
         
    if @state.subjects_next_page
      nextButton = <Link className="button" to={@state.subjects_next_page}>Next Label</Link>
    else
      nextButton = <span/>         
      
    <div className="view">
      <div className="row align-center">
        <div className="columns text-center">{prevButton}</div> 
        <div className="columns text-center">{nextButton}</div>
      </div>
      <section className="row align-center view-group">
        {
          if subject
            <figure className="main-wine-label" key={subject.id}>
              <img src={subject.location.standard} width={subject.width / 2} height={subject.height / 2} />
            </figure>
        }
      </section>
      <div className="row align-center">
        <div className="columns text-center">{prevButton}</div>
        <div className="columns text-center">{nextButton}</div>        
      </div>              
    </div>

