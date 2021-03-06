React                  = require 'react'
DraggableModal         = require 'components/draggable-modal'
SmallButton            = require 'components/buttons/small-button'
HelpButton             = require 'components/buttons/help-button'
BadSubjectButton       = require 'components/buttons/bad-subject-button'
IllegibleSubjectButton = require 'components/buttons/illegible-subject-button'

TextTool = React.createClass
  displayName: 'TextTool'

  getInitialState: ->
    annotation: @props.annotation ? {}
    viewerSize: @props.viewerSize
    autocompleting: false

  # this can go into a mixin? (common across all transcribe tools)
  getPosition: (data) ->
    return x: null, y: null if ! data.x?

    yPad = 20
    modalWidth = 480  # Approximate width of the modal
    switch data.toolName
      when 'rectangleTool'
        x = data.x
        y = parseFloat(data.y) + parseFloat(data.height) + yPad
      when 'textRowTool'
        x = data.x
        y = data.yLower + yPad
      else # default for pointTool
        x = data.x
        y = data.y + yPad if data.y?
    x = @props.subject.width / 2 if ! x?
    y = @props.subject.height / 2 if ! y?

    # Handle if we're off the edge of the viewport
    if (x > $(window).width() - modalWidth)
      x = ($(window).width() - modalWidth) + (modalWidth / 2)

    return {x,y}

  getDefaultProps: ->
    annotation: {}
    annotation_key: null
    task: null
    subject: null
    standalone: true
    focus: true
    inputType: 'text'

  componentWillUnmount: ->
    # Autocomplete was removed
    tool_config = @toolConfig()
    #if tool_config.suggest == 'common'
  #    el = $(@refs.input0.getDOMNode())
  #    el.autocomplete 'destroy' if el.autocomplete?

  toolConfig: ->
    @props.tool_config ? @props.task.tool_config

  # Set focus on input:
  focus: ->
    el = $(@refs.input0?.getDOMNode())
    if el? && el.length
      el.focus()

  componentWillReceiveProps: (new_props) ->
    # PB: Note this func is defined principally to allow a parent composite-tool
    # to set focus on a child tool via props but this consistently fails to
    # actually set focus - probably because the el.focus() call is made right
    # before an onkeyup event or something, which quietly reverses it.
    if new_props.focus
      @focus()

    # Squash autocomplete for now - LD Aug 12 2016
    # @applyAutoComplete()

    # Required to ensure tool has cleared annotation even if tool doesn't unmount between tasks:
    @setState
      annotation: new_props.annotation ? {}
      viewerSize: new_props.viewerSize

  shouldComponentUpdate: ->
    true

  componentDidMount: ->
    # @applyAutoComplete()
    @focus() if @props.focus

  componentDidUpdate: ->
    # @applyAutoComplete()
    @focus() if @props.focus

  applyAutoComplete: ->
    if @isMounted() && @toolConfig().suggest == 'common'
      el = $(@refs.input0?.getDOMNode())
      el.autocomplete
        open: ( => @setState autocompleting: true )
        close: => setTimeout( (=> @setState(autocompleting: false)), 1000)
        select: (e, ui) => @updateValue(ui.item.value)
        source: (request, response) =>
          field = "#{@props.task.key}:#{@fieldKey()}"
          $.ajax
            url: "/classifications/terms/#{@props.workflow.id}/#{field}"
            dataType: "json"
            data:
              q: request.term
            success: ( data ) =>
              response( data )
        minLength: 3

  # Expects size hash with:
  #   w: [viewer width]
  #   h: [viewer height]
  #   scale:
  #     horizontal: [horiz scaling of image to fit within above vals]
  #     vertical:   [vert scaling of image..]
  onViewerResize: (size) ->
    @setState
      viewerSize: size

  # this can go into a mixin? (common across all transcribe tools)
  # NOTE: doesn't get called unless @props.standalone is true
  commitAnnotation: ->
    ann = @state.annotation
    @props.onComplete ann

    if @props.transcribeMode is 'page' or @props.transcribeMode is 'single'
      if @props.isLastSubject and not @props.task.next_task?
        @props.returnToMarking()

  # Get key to use in annotations hash (i.e. typically 'value', unless included in composite tool)
  fieldKey: ->
    if @props.standalone
      'value'
    else
      @props.annotation_key

  getCaret: ()->
    el = $(@refs.input0?.getDOMNode())

  updateValue: (val) ->
    newAnnotation = @state.annotation
    newAnnotation[@fieldKey()] = val

    # if composite-tool is used, this will be a callback to CompositeTool::handleChange()
    # otherwise, it'll be a callback to Transcribe::handleDataFromTool()
    @props.onChange(newAnnotation) # report updated annotation to parent

  handleChange: (e) ->
    @updateValue e.target.value

  handleKeyDown: (e) ->
    @handleChange(e) # updates any autocomplete values

    if (! @state.autocompleting && [13].indexOf(e.keyCode) >= 0) && !e.shiftKey# ENTER
      @commitAnnotation()
      e.preventDefault()

    else if e.keyCode == 13 && e.shiftKey
      text_area =  $("textarea")
      the_text = text_area.val()
      the_text = the_text.concat("/n")
      text_area.val(the_text)

  handleBadMark: ()->
    newAnnotation = []
    newAnnotation["low_quality_subject"]

  render: ->
    return null if @props.loading # hide transcribe tool while loading image

    val = @state.annotation[@fieldKey()]
    val = '' if ! val?

    unless @props.standalone
      label = @props.label ? ''
      label = label[0] if Array.isArray(label)
    else
      label = @props.task.instruction

    ref = @props.ref || "input0"

    # Grab examples either from examples in top level of task or (for composite tool) inside this field's option hash:
    examples = @props.task.examples ? ( t for t in (@props.task.tool_config?.options ? []) when t.value==@props.annotation_key )[0]?.examples

    {x,y} = @getPosition @props.subject.region

    if @props.task.key == 'image'
      title = <h2>Describe this Element</h2>
      illegible_button = "I can't tell what this is"
    else
      title = <h2>Transcribe this text</h2>
      illegible_button = "This text is illegible"

    if @props.isLastSubject
      buttonLabel = 'Finish Transcribing'
    else
      buttonLabel = 'Continue'

    # create component input field(s)
    tool_content =

     <DraggableModal
        x={x*@props.scale.horizontal + @props.scale.offsetX}
        y={y*@props.scale.vertical + @props.scale.offsetY}
        classes="transcribe-tool">

      <div className="input-field active">
        <label>

          { title }

          <p>{@props.task.instruction}</p>
          {
            atts =
              ref: ref
              key: "#{@props.task.key}.#{@props.annotation_key}"
              "data-task_key": @props.task.key
              onKeyDown: @handleKeyDown
              onChange: @handleChange
              onFocus: ( () => @props.onInputFocus? @props.annotation_key )
              value: val
              disabled: @props.badSubject

            if @props.inputType == "text"
              <input type="text" value={val} {...atts} placeholder="Enter text here"/>

            else if @props.inputType == "textarea"
              <textarea key={@props.task.key} value={val} {...atts} placeholder="Enter text here"></textarea>

            else if @props.inputType == "number"
              # Let's not make it input[type=number] because we don't want the browser to absolutely *force* numeric; We should coerce numerics without obliging
              <input type="text" value={val} {...atts} />

            else if @props.inputType == "date"
              <input type="date" value={val} {...atts} />

            else console.warn "Invalid inputType specified: #{@props.inputType}"
        }
        </label>
        <div className="button-group align-right">
          <IllegibleSubjectButton label={illegible_button} key="illegal-subject-button" active={@props.illegibleSubject} onClick={() => @props.onIllegibleSubject(@commitAnnotation)} />
          <SmallButton label={buttonLabel} key="done-button" onClick={@commitAnnotation} />


        </div>
      </div>
    </DraggableModal>


module.exports = TextTool
