React                         = require 'react'
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

  toggleShowTooltip: ->
    if @state.tooltipExpanded
      @onHideTooltip()
    else
      @onShowTooltip()

  onShowTooltip: ->
    @setState tooltipExpanded: true

  onHideTooltip: ->
    @setState tooltipExpanded: false

  render: ->
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
              <label className="switch-paddle" htmlFor="exampleSwitch" onMouseOver={@toggleShowTooltip} onMouseOut={@toggleShowTooltip}>
                <span className={"tooltip helper" + if @state.tooltipExpanded then ' active' else '' }>Show Others Users' Marks</span>
              </label>
           </div>
        </div>
      </div>
    </div>
