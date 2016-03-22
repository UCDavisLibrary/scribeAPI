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
    type: 'root'

  componentDidUpdate: (prev_props) ->
    if prev_props.hash != @props.hash
      @_fetchByProps()
        
  getInitialState: ->
    subjects: []
    
  render: ->
    if @state.subjects[0]?.order > 1
       prevButton = <GenericButton onClick={@prevPage} label="Prev" />
    else
       prevButton = <span/>

    nextButton = <GenericButton onClick={@nextPage} label="Next" />

    <div className="view">
      <div className="view-nav row">
        <div className="columns">{prevButton}</div>
        <div className="columns">{nextButton}</div>
      </div>
      { 
        for subject in @state.subjects
          <div className="view-group columns" key={subject.id}>
             <div className="column">
               <img src={subject.location.standard} width={subject.width / 2} height={subject.height / 2} />
             </div>
          </div>
      }
      <div className="view-nav row">
        <div className="columns">{prevButton}</div>
        <div className="columns">{nextButton}</div>        
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
    window.history.pushState({page: @props.page}, '', '#/view/index/' + nextPage)

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
          

