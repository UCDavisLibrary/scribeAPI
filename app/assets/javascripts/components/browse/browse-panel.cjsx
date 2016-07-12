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
  displayName: "BrowsePanel"
  mixins: [Navigation, FetchSubjectsMixin]

  getDefaultProps: ->
    page: 1
    browse: true
    limit: MAX_COLS * MAX_ROWS
    type: 'root'
    show_pagination: true

  componentWillReceiveProps: (newProps) ->
    if @props.page != newProps.page
      @fetchSubjects newProps

  getInitialState: ->
    subjects: []

  render: ->
    if @props.show_pagination
      pagination =  <div className="browse-nav row">
          <Pagination currentPage={@state.subjects_current_page}
            nextPage={@state.subjects_next_page}
            previousPage={@state.subjects_prev_page}
            urlBase="/browse"
            totalPages={@state.subjects_total_pages}/>
        </div>
    else
      pagination = <span/>

    <div className="browse">
      { pagination }
      <div className="browse-group columns">
         <div className="row small-up-2 medium-up-4 large-up-5 align-center">
            {
             for subj, index in @state.subjects
               <div className="column" key={index}>
                 <Link className="thumbnail" to="/view/#{subj.meta_data.identifier}">
                   <img src={subj.location.thumbnail} width="200" height="200"/>
                 </Link>
               </div>
            }
          </div>
      </div>
      { pagination }
   </div>
