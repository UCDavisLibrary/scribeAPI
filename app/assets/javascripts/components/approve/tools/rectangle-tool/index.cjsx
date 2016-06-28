React           = require 'react'
Draggable       = require 'lib/draggable'
DragHandle      = require './drag-handle'
DeleteButton    = require 'components/buttons/delete-mark'
MarkButtonMixin = require 'lib/mark-button-mixin'
API = require 'lib/api'
LabelDisplay = require '../label-tool'

MINIMUM_SIZE = 15
DELETE_BUTTON_ANGLE = 45
DELETE_BUTTON_DISTANCE_X = -20
DELETE_BUTTON_DISTANCE_Y = -10
DEBUG = false

module.exports = React.createClass
  displayName: 'ApproveRectangleTool'

  mixins: [MarkButtonMixin]

  propTypes:
    # key:  React.PropTypes.number.isRequired
    mark: React.PropTypes.object.isRequired

  initCoords: null

  statics:
    defaultValues: ({x, y}) ->
      x: x
      y: y
      width: 0
      height: 0

    initStart: ({x,y}, mark) ->
      @initCoords = {x,y}
      {x,y}

    initMove: (cursor, mark) ->
      if cursor.x > @initCoords.x
        width = cursor.x - mark.x
        x = mark.x
      else
        width = @initCoords.x - cursor.x
        x = cursor.x

      if cursor.y > @initCoords.y
        height = cursor.y - mark.y
        y = mark.y
      else
        height = @initCoords.y - cursor.y
        y = cursor.y

      {x, y, width, height}

    initValid: (mark) ->
      mark.width > MINIMUM_SIZE and mark.height > MINIMUM_SIZE

    # This callback is called on mouseup to override mark properties (e.g. if too small)
    initRelease: (coords, mark, e) ->
      mark.width = Math.max mark.width, MINIMUM_SIZE
      mark.height = Math.max mark.height, MINIMUM_SIZE
      mark

  getInitialState: ->
    mark = @props.mark
    unless mark.status?
      mark.status = 'mark'
    mark: mark

    # set up the state in order to calculate the polyline as rectangle
    x1 = @props.mark.x
    x2 = x1 + @props.mark.width
    y1 = @props.mark.y
    y2 = y1 + @props.mark.height

    pointsHash: @createRectangleObjects(x1, x2, y1, y2)

    buttonDisabled: false
    lockTool: false

  componentDidMount: ->
    # If the mark tool is currently active, add an event listener to close the modal on ESC
    if @props.selected
      document.addEventListener("keydown", @handleEscKey)



  componentWillUnmount: ->
    document.removeEventListener("keydown", @handleEscKey)

  handleEscKey: (event) ->
    if event.keyCode == 27
      @props.onDestroy()

  componentWillReceiveProps:(newProps)->
    x1 = newProps.mark.x
    x2 = x1 + newProps.mark.width
    y1 = newProps.mark.y
    y2 = y1 + newProps.mark.height

    @setState pointsHash: @createRectangleObjects(x1, x2, y1, y2)

  createRectangleObjects: (x1 , x2, y1, y2) ->
    if x1 < x2
      LX = x1
      HX = x2
    else
      LX = x2
      HX = x1

    if y1 < y2
      LY = y1
      HY = y2
    else
      LY = y2
      HY = y1

    # PB: L and H seem to denote Low and High values of x & y, so:
    # LL: upper left
    # HL: upper right
    # HH: lower right
    # LH: lower left
    pointsHash = {
      handleLLDrag: [LX, LY],
      handleHLDrag: [HX, LY],
      handleHHDrag: [HX, HY],
      handleLHDrag: [LX, HY]
    }

  handleMainDrag: (e, d) ->
    return if @state.locked
    return if @props.disabled
    @props.mark.x += d.x / @props.xScale
    @props.mark.y += d.y / @props.yScale
    @assertBounds()
    @props.onChange e

  dragFilter: (key) ->
    if key == "handleLLDrag"
      return @handleLLDrag
    if key == "handleLHDrag"
      return @handleLHDrag
    if key == "handleHLDrag"
      return @handleHLDrag
    if key == "handleHHDrag"
      return @handleHHDrag

  handleLLDrag: (e, d) ->
    @props.mark.x += d.x / @props.xScale
    @props.mark.width -= d.x / @props.xScale
    @props.mark.y += d.y / @props.yScale
    @props.mark.height -= d.y / @props.yScale
    @props.onChange e

  handleLHDrag: (e, d) ->
    @props.mark.x += d.x / @props.xScale
    @props.mark.width -= d.x / @props.xScale
    @props.mark.height += d.y / @props.yScale
    @props.onChange e

  handleHLDrag: (e, d) ->
    @props.mark.width += d.x / @props.xScale
    @props.mark.y += d.y / @props.yScale
    @props.mark.height -= d.y / @props.yScale
    @props.onChange e

  handleHHDrag: (e, d) ->
    @props.mark.width += d.x / @props.xScale
    @props.mark.height += d.y / @props.yScale
    @props.onChange e


  assertBounds: ->
    @props.mark.x = Math.min @props.sizeRect.props.width - @props.mark.width, @props.mark.x
    @props.mark.y = Math.min @props.sizeRect.props.height - @props.mark.height, @props.mark.y

    @props.mark.x = Math.max 0, @props.mark.x
    @props.mark.y = Math.max 0, @props.mark.y

    @props.mark.width = Math.max @props.mark.width, MINIMUM_SIZE
    @props.mark.height = Math.max @props.mark.height, MINIMUM_SIZE

  validVert: (y,h) ->
    y >= 0 && y + h <= @props.sizeRect.props.height

  validHoriz: (x,w) ->
    x >= 0 && x + w <= @props.sizeRect.props.width

  getDeleteButtonPosition: ()->
    points = @state.pointsHash["handleLLDrag"]
    x = points[0] + DELETE_BUTTON_DISTANCE_X / @props.xScale
    y = points[1] + DELETE_BUTTON_DISTANCE_Y / @props.yScale
    x = Math.min x, @props.sizeRect.props.width - 15 / @props.xScale
    y = Math.max y, 15 / @props.yScale
    {x, y}

  getMarkButtonPosition: ()->
    points = @state.pointsHash["handleHHDrag"]
    x: Math.min points[0], @props.sizeRect.props.width - 40 / @props.xScale
    y: Math.min points[1] + 20 / @props.yScale, @props.sizeRect.props.height - 15 / @props.yScale

  # LD Add buttons for text/image marking
  getMarkSelectionButtonPosition: ()->
    points = @state.pointsHash["handleHHDrag"]
    scaledX = @props.sizeRect.props.width - 140 / @props.xScale
    x: Math.min points[0], scaledX
    y: Math.min points[1] - 100 / @props.yScale,  @props.sizeRect.props.height - 15 / @props.yScale

  handleMouseDown: ->
    @props.onSelect @props.mark

  normalizeMark: ->
    if @props.mark.width < 0
      @props.mark.x += @props.mark.width
      @props.mark.width *= -1

    if @props.mark.height < 0
      @props.mark.y += @props.mark.height
      @props.mark.height *= -1

    @props.onChange()

  markSelectionAsImage: ->
    @props.mark.override_task_key = 'image-on-label'
    @props.submitMark @props.mark
    document.removeEventListener("keydown", @handleEscKey, false)

  markSelectionAsText: ->
    @props.mark.override_task_key = 'text-on-label'
    @props.submitMark @props.mark
    document.removeEventListener("keydown", @handleEscKey, false)

  handleSelection: (e) ->
    subject_id = @props.mark.subject_id
    svgEl = e.target
    parentEl = $('.subject-viewer-svg')[0]
    labelEl = $('#label-' + subject_id)
    pos = svgEl.getBoundingClientRect()

    labelX = pos.left + document.body.scrollLeft + (pos.width / 2) - (labelEl.width() / 2)
    labelY = pos.top + document.body.scrollTop + pos.height

    labelEl.css('top', labelY).css('left', labelX).show()

  render: ->
    classes = []
    classes.push 'transcribable' if @props.isTranscribable
    classes.push 'interim' if @props.interim
    classes.push if @props.disabled then 'committed' else 'uncommitted'
    classes.push "tanscribing" if @checkLocation()

    x1 = @props.mark.x
    width = @props.mark.width
    x2 = x1 + width
    y1 = @props.mark.y
    height = @props.mark.height
    y2 = y1 + height

    scale = (@props.xScale + @props.yScale) / 2

    points = [
      [x1, y1].join ','
      [x2, y1].join ','
      [x2, y2].join ','
      [x1, y2].join ','
      [x1, y1].join ','
    ].join '\n'


    <g
      tool={this}
      onMouseDown={@handleSelection}
      title={@props.mark.label}
    >
      <g className="rectangle-tool">
        <Draggable onDrag = {@handleMainDrag} >
          <g
            className="tool-shape"
            key={points}>
              <polyline stroke="rgb(0,0,0)" points={points} />
          </g>
        </Draggable>
      </g>

    </g>
