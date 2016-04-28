React = require 'react'
{Navigation} = require 'react-router'
{Link} = require 'react-router'
API = require 'lib/api'
FetchSubjectsMixin = require 'lib/fetch-subjects-mixin'
SubjectMetadata = require '../subject-metadata'

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
    if subject?
      if @state.subjects_prev_page
        prevButton = <Link className="secondary button previous-label" to={@state.subjects_prev_page}><img className="left-pointer" src="../../images/left-pointer-red.svg"/>Previous Label</Link>
      else
        prevButton = <span/>
          
      if @state.subjects_next_page
        nextButton = <Link className="secondary button next-label" to={@state.subjects_next_page}>Next Label<img className="right-pointer" src="../../images/right-pointer-red.svg"/></Link>
      else
        nextButton = <span/>         
      
      <div className="view">
        <section className="row align-justify toolbar">      
          {prevButton}
          <div className="columns align-self-middle single label-title">Label { subject.meta_data.identifier }</div>        
          {nextButton}
        </section>
        <section className="row align-center">
          {
            <figure className="main-wine-label" key={subject.id}>
              <img src={subject.location.standard} width={subject.width / 2} height={subject.height / 2} />
            </figure>
          }
        </section>
        <SubjectMetadata subject={subject} key={subject.meta_data.identifier} />
      </div>

    else
      <div/>
