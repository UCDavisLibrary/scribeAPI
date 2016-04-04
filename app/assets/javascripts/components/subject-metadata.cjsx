# @cjsx React.DOM

React = require 'react'

SubjectMetadata = React.createClass
  displayName: "Metadata"

  render: ->
      <section className="medium-10 medium-offset-1 medium-unstack row">
          <div className="column">
            <h1>Label #XXXXX</h1>
              <dl>
                <dt>Definition List</dt>
                  <dd>A number of connected items or names written or printed consecutively, typically one below the other.</dd>
                  <dt>This is a term.</dt>
                  <dd>This is the definition of that term.</dd>
                  <dt>Here is another term.</dt>
                  <dd>And it gets a definition too, which is this line.</dd>
                <dt>Here is term that shares a definition with the term below.</dt>
                  <dd>And it gets a definition too, which is this line.</dd>
              </dl>              
          </div>
          <div className="small-4 columns">
            <div className="row small-10 align-spaced">
              <a className="webicon facebook" href="#">Facebook</a>
              <a className="webicon pinterest" href="#">Pinterest</a>
              <a className="webicon twitter" href="#">Twitter</a>
            </div>
            <h5>Status: Needs transcribing</h5>
            <p><a href="#" className="button">Mark this Label</a></p>
            <h5>Get the story behind this label:</h5>
            <h6><a href="">Who was Maynard Amerine?</a></h6>
            <h5>Tell us your story</h5>
            <p>Are you a wine expert? Do you have family history with this label? <a href="#">Send us your story</a>!</p>
          </div>
      </section>        

module.exports = SubjectMetadata
