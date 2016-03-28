React = require 'react'
{Navigation} = require 'react-router'
{Link} = require 'react-router'
API = require 'lib/api'
FetchSubjectsMixin = require 'lib/fetch-subjects-mixin'

module.exports = React.createClass
  displayName: "ViewPanel"
  mixins: [Navigation, FetchSubjectsMixin]

  getDefaultProps: ->
    page: 1
    browse: true
    limit: 1
    type: 'root'

  componentWillReceiveProps: (newProps) ->
    if @props.page != newProps.page
      @fetchSubjects newProps

  getInitialState: ->
    subjects: []
    
  render: ->
    console.log(@state.subjects[0]?.order)
    
    if @state.subjects[0]?.order > 0
       prevButton = <a className="button" onClick={@prevPage}>Previous Label</a>
    else
       prevButton = <span/>

    nextButton = <a className="button" onClick={@nextPage}>Next Label</a>

    <div className="view">
      <div className="row align-center">
        <div className="columns text-center">{prevButton}</div>
        <div className="columns text-center">{nextButton}</div>
      </div>
      <section className="row align-center view-group">
      { 
        for subject in @state.subjects
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
           
  nextPage: ->
    params =
      type: @props.type 
      limit: @props.limit
      browse: true
      order_dir: "next"
      order_filter: @state.subjects[0]?.order,
      
    @fetchSubjects(params)
    nextPage = parseInt(@state.subjects[0]?.order) + 1
    window.history.pushState({page: @props.page}, '', '#/view/' + @state.subjects[0]?.getMeta("subject_set_id"))

  prevPage: ->
    params =
      type: @props.type 
      limit: @props.limit
      browse: true
      order_filter: @state.subjects[0]?.order - 1,
      order_dir: "prev"

    @fetchSubjects(params)
    
    prevPage = parseInt(@state.subjects[0]?.order) + 1
    window.history.pushState({page: @props.page}, '', '#/view/index/' + prevPage)
          

