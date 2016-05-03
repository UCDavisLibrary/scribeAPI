React                         = require 'react'
LightBox                      = require './light-box'
ForumSubjectWidget            = require './forum-subject-widget'
{Link}                        = require 'react-router'
SubjectZoomPan          = require 'components/subject-zoom-pan'

module.exports = React.createClass
  displayName: "SubjectSetToolbar"
  
  propTypes:
    hideOtherMarks: React.PropTypes.bool.isRequired

  getInitialState: ->
    hideMarks: true
    zoomExpanded: false
    viewBox: @props.viewBox
  onZoomExpand: ->
    @setState zoomExpanded: true

  onZoomHide: ->
    @setState zoomExpanded: false
 
  toggleZoom: ->
    if @state.zoomExpanded
      @onZoomHide()
    else
      @onZoomExpand()

        
  render: ->
    # disable LightBox if work has begun
    disableLightBox = if @props.task.key isnt @props.workflow.first_task then true else false
    <div>
      <div className="row tools">
        <div className="pan-zoom-controller" onMouseOver={@toggleZoom} onMouseOut={@toggleZoom}>          

          <div className={"pan-zoom-area pan-zoom pane" + if @state.zoomExpanded then ' active' else '' }>
            <SubjectZoomPan subject={@props.subject} handleZoomUI={@props.handleZoomUI} />
          </div>
        </div>
        <div className="switch">
           <div className="toggle">
              <input className="switch-input" id="exampleSwitch" type="checkbox" name="exampleSwitch" onClick={@props.toggleHideOtherMarks}/>
              <label className="switch-paddle" htmlFor="exampleSwitch">
                 <span className="show-for-sr">Show Others’ Marks</span>
              </label>
           </div>
        </div>
      </div>
    </div>
