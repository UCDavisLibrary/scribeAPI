
React         = require("react")
GroupBrowser  = require('./group-browser')
NameSearch    = require('./name-search')
BrowsePanel   = require 'components/browse/browse-panel'
{Navigation}  = require 'react-router'
{Link} = require 'react-router'

HomePage = React.createClass
  displayName : "HomePage"
  mixins: [Navigation]

  componentWillReceiveProps: (new_props) ->
    @setState project: new_props.project

  markClick: ->
    @transitionTo 'mark', {}

  transcribeClick: ->
    @transitionTo 'transcribe', {}


  render:->
     <div className="row">

       <section className="intro small-12 medium-10 medium-offset-1 large-8 large-offset-2 columns">

         <h1 className="title"></h1>
          
         <p className="lead">The labels in the Maynard Amerine Collection at the UC Davis Libary tell the story of the growing wine industry in
         California. Many of them are meaningful windows into the fabric of both winemaking and winemakers and should be
         searchable in a way that accessible.</p>
           
         <p className="lead">Before we can create a searchable database, we need to transcribe the labels. That’s where you come in! Help us
         uncork a piece of history.</p>

   			 <div className="row align-center">
           <Link to="/mark" className="button large">Get Started</Link>        
   			 </div>
       </section>
 		   <section className="small-12 medium-10 medium-offset-1 large-8 large-offset-2 columns">           
         <h2>Just want to look at the pretty labels?</h2>

         <p>Since the labels aren’t transcribed yet, they’re just ordered randomly. That’s why we need your help. As we
         transcribe more labels, we’ll be able to gather more information about them. That will help us organize how we
         present them to you.</p>
          
         <p>In the meantime, you can browse through the labels at random below, or search for terms within the labels we’ve transcribed so far.</p>
    
         <BrowsePanel project={@props.project} page={"1"} show_pagination={false}/>

         <div className="row align-center">
           <Link className="small secondary button" to="/browse">Browse More Labels</Link>
         </div>           
        </section>
     </div>
        
module.exports = HomePage
 
