# @cjsx React.DOM

React = require 'react'
{Navigation} = require 'react-router'
{Link} = require 'react-router'

SubjectMetadata = React.createClass
  displayName: "Metadata"

  getDefaultProps: ->
    subject: null
    nextTask: 'mark'
    
  render: ->
    if @props.subject
      <section className="medium-10 medium-offset-1 medium-unstack row">
          <div className="column">
            <h1>Label #{@props.subject.meta_data.identifier}</h1>
              { if @props.subject.meta_data.category 
                  <dl>
                    <dt>Category</dt>
                    <dd>{@props.subject.meta_data.category}</dd>
                    { if @props.subject.meta_data.subcategory
                      <div>
                        <dt>Subcategory</dt>
                        <dd>{@props.subject.meta_data.sub_category}</dd>
                      </div>
                    }
                  </dl>
               }
          </div>
          <div className="small-4 columns">
            <div className="row small-10 align-spaced">
              <a className="webicon facebook" href="#">Facebook</a>
              <a className="webicon pinterest" href="#">Pinterest</a>
              <a className="webicon twitter" href="#">Twitter</a>
            </div>
            { if @props.nextTask == 'mark'
               <div>
                 <h5>Status: Needs marking</h5>
                 <p><Link to="/mark?subject_set_id=#{@props.subject.subject_set_id}&selected_subject_id=#{@props.subject.id}" className="button">Mark this Label</Link></p>
               </div>
            }
            <h5>Get the story behind this label:</h5>
            <h6><a href="">Who was Maynard Amerine?</a></h6>
            <h5>Tell us your story</h5>
            <p>Are you a wine expert? Do you have family history with this label? <a href="#">Send us your story</a>!</p>
          </div>
      </section>        
    else
      <section></section>
module.exports = SubjectMetadata
