React     = require 'react'
HelpModal = require './help-modal'
DraggableModal  = require 'components/draggable-modal'

module.exports = React.createClass
  displayName: 'Tutorial'

  propTypes:
    tutorial: React.PropTypes.object.isRequired
    onCloseTutorial: React.PropTypes.func.isRequired

  getInitialState:->
    currentTask: @props.tutorial.first_task
    nextTask: @props.tutorial.tasks[@props.tutorial.first_task].next_task
    completedSteps: 0
    doneButtonLabel: "Next"

  advanceToNextTask:->
    if @props.tutorial.tasks[@state.currentTask].next_task == null
      @onClose()

    else
      @setState
        currentTask: @state.nextTask
        nextTask: @props.tutorial.tasks[@state.nextTask].next_task
        completedSteps: @state.completedSteps + 1

  onClose: ->
    # LD 
    localStorage.setItem('seen_tutorial', true)
    @animateClose()
    @props.onCloseTutorial()

  animateClose: ->
    $modal = $(@refs.tutorialModal.getDOMNode())
    $clone = $modal.clone()
    $link = $('.tutorial-link').first()
    if $link.length
      x1 = $modal.offset().left - $(window).scrollLeft()
      y1 = $modal.offset().top - $(window).scrollTop()
      x2 = $link.offset().left - $(window).scrollLeft()
      y2 = $link.offset().top - $(window).scrollTop()
      xdiff = x2 - x1
      ydiff = y2 - y1
      $modal.parent().append($clone)
      $clone.animate {
          opacity: 0
          left: '+=' + xdiff
          top: '+=' + ydiff
          width: 'toggle'
          height: 'toggle'
        }, 500, ->
          $clone.remove()

  onClickStep: (index) ->
    taskKeys = Object.keys(@props.tutorial.tasks)
    taskKey = taskKeys[index]
    task = @props.tutorial.tasks[taskKey]
    @setState
      currentTask: taskKey
      nextTask: task.next_task
      completedSteps: index

  render:->
    helpContent = @props.tutorial.tasks[@state.currentTask].help
    taskKeys = Object.keys(@props.tutorial.tasks)

    if @state.nextTask != null
      doneButtonLabel = "Next"
    else
      doneButtonLabel = "Done"

    progressSteps = []
    for key, step of @props.tutorial.tasks
      progressSteps.push step
    
    <DraggableModal ref="tutorialModal" width={570} classes="help-diagogue">
      {
        if @state.currentTask and @state.currentTask == "marking"
          <div>
            <label>
              <h2>How to Mark this label</h2>
                <p>Before we can transcribe the labels, we need to know which sections need transcription.</p>
                <p>You can help us by marking up the labels — draw a box around each area of interest on the label, and log it as an image or as a piece of text. Mark as many areas as you want.</p>
                <p>Try to keep phrases or groups of words that look like they belong together in one box.</p>
                <figure>
                  <img src="/images/fpo_4x3.png" alt="4x3 Image" />
                </figure>
                <div className="button-group align-center">
                  <a onClick={@onClose} className="button">OK, got it!</a>
                </div>
              </label>          
          </div>
        else
          <div></div>
          
      }
      
    </DraggableModal>
