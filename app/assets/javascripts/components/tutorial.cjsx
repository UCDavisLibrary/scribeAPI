React     = require 'react'
HelpModal = require './help-modal'
DraggableModal  = require 'components/draggable-modal'

module.exports = React.createClass
  displayName: 'Tutorial'

  propTypes:
    workflow: React.PropTypes.object.isRequired
    onCloseTutorial: React.PropTypes.func.isRequired

  onClose: ->
    @props.onCloseTutorial()

  render:->

    <DraggableModal ref="tutorialModal" width={570} y="150" classes="help-dialogue">
      {
        if @props.workflow.name == "mark"
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
        else if @props.workflow.name == "transcribe"
          <div>
            <label>
              <h2>How to Transcribe this label</h2>
                <p>Please tell us what the highlighted text says. Try to include any diacritics, like accents ( ` ) or umlauts ( ¨ ), as well as upper and lower case letters.</p>
                <p>If something is illegible, that is important information for us to know as well, so please mark it as illegible.</p>
                <p>If the area highlighted is an image, please use on or two words to describe the image.</p>
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
