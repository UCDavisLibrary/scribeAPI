React = require 'react'
{Navigation} = require 'react-router'
{Link} = require 'react-router'
API = require 'lib/api'

GenericButton = require 'components/buttons/generic-button'
FetchSubjectsMixin = require 'lib/fetch-subjects-mixin'
Pagination = require 'components/core-tools/pagination'

MAX_COLS = 5
MAX_ROWS = 6

module.exports = React.createClass
  displayName: "Browse"
  mixins: [Navigation, FetchSubjectsMixin]
  
  getDefaultProps: ->
    page: 1
    browse: true
    limit: MAX_COLS * MAX_ROWS
    type: 'root'
    
  componentDidUpdate: (prev_props) ->
    if prev_props.hash != @props.hash
      @_fetchByProps()
      
  getInitialState: ->
    subjects: []

  render: ->
    pagination = <Pagination currentPage={@state.subjects_current_page} nextPage={@state.subjects_next_page} previousPage={@state.subjects_prev_page} totalResults={@state.subjectsTotalResults} urlBase="/browse" totalPages={@state.subjects_total_pages}/>
      
    <div className="browse">
      <div className="browse-nav row">
        { pagination }
      </div>
      <div className="browse-group columns"> 
         <div className="row small-up-2 medium-up-4 large-up-5 align-center">       
            {
             for subj, index in @state.subjects
               <div className="column" key={index}>
                 <Link className="thumbnail" to="/view/index/#{subj.order}">
                   <img src={subj.location.thumbnail} width="200" height="200"/>
                 </Link>
               </div>
            }
          </div>
      </div>
      <div className="browse-nav row">
        { pagination }        
      </div>
   </div>
           

