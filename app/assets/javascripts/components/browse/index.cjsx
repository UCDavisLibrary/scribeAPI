React = require 'react'
{Navigation} = require 'react-router'
{Link} = require 'react-router'
API = require 'lib/api'

GenericButton = require 'components/buttons/generic-button'
Pagination = require 'components/core-tools/pagination'

BrowsePanel = require './browse-panel'

MAX_COLS = 5
MAX_ROWS = 6

module.exports = React.createClass
  displayName: "Browse"
  mixins: [Navigation]
  
  render: ->
    <div>
      <section className="medium-10 medium-offset-1 large-8 large-offset-2 row align-middle">
        <div className="column">
          <h3>Help us uncork a piece of history</h3>
          <p>Before we can create a searchable database, we need to transcribe the labels. That’s where you come in!</p>
        </div>
        <div className="shrink">
          <Link className="button" to="/mark">Get started</Link>
        </div>
      </section>
      <section className="medium-10 medium-offset-1 large-8 large-offset-2 columns ">
        <h1>Browse labels randomly</h1>
          
        <BrowsePanel project={@props.project} page={@props.params.page} />
      </section>
    </div>           
 
