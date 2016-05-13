React = require 'react'
{Navigation} = require 'react-router'
{Link} = require 'react-router'

BrowsePanel = require './browse-panel'
 
module.exports = React.createClass
  displayName: "Browse"
  mixins: [Navigation]
  
  render: ->
    <div>
      <section className="row align-justify toolbar">
        <div></div>
        <div className="columns align-center label-title">
          <div className="browse-instructions small-12">
            <h1>Help us uncork a piece of history</h1>
            <p><small>You can currently browse labels at random. Before we can create a searchable database, we need to transcribe the labels. That’s where you come in!</small></p>            
          </div>
        </div>
        <Link className="secondary button next-label" to="/mark">Get started<img className="right-pointer" src="/images/right-pointer-red.svg"/></Link>
      </section>
      <section className="medium-10 medium-offset-1 large-8 large-offset-2 columns browse">
        <h1>Browse labels randomly</h1>
        <BrowsePanel project={@props.project}  page={@props.params.page} show_pagination={true} />
      </section>
    </div>           
 
