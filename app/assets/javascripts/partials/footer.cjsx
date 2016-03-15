React                   = require 'react'

Footer = React.createClass
  displayName: 'Footer'

  propTypes:->
    privacyPolicy: @props.privacyPolicy

  getInitialState: ->
    categories: null

  render: ->
    <footer className="row expanded">
     <div className="columns">
      Help 
     </div>
     <div className="columns">
       Questions or Comments?  
     </div>
     <div className="columns">
       Privacy & Accessibility 
     </div>
     <div className="columns">
       Principles of Community 
     </div>
     <div className="columns">
       University of California
     </div>       
    </footer>

module.exports = Footer

