# @cjsx React.DOM
React              = require 'react'
{Navigation}       = require 'react-router'
SubjectViewer      = require '../subject-viewer'
JSONAPIClient      = require 'json-api-client' # use to manage data?
FetchSubjectsMixin = require 'lib/fetch-subjects-mixin'
ForumSubjectWidget = require '../forum-subject-widget'

BaseWorkflowMethods     = require 'lib/workflow-methods-mixin'

DraggableModal          = require 'components/draggable-modal'
GenericButton           = require 'components/buttons/generic-button'
Tutorial                = require 'components/tutorial'
HelpModal               = require 'components/help-modal'

# Hash of core tools:
coreTools          = require 'components/core-tools'

# Hash of transcribe tools:
verifyTools   = require './tools'

API                = require '../../lib/api'

module.exports = React.createClass # rename to Classifier
  displayName: 'Verify'
  mixins: [FetchSubjectsMixin, BaseWorkflowMethods, Navigation] # load subjects and set state variables: subjects,  classification

  getDefaultProps: ->
    workflowName: 'verify'

  getInitialState: ->
    taskKey:                      null
    classifications:              []
    classificationIndex:          0
    subject_index:                0
    showingTutorial:              false
    helping:                      false
    subject_id:                   @props.params?.subject_id
    
  componentWillMount: ->
    @beginClassification()

  fetchSubjectsCallback: ->
    if @getCurrentSubject()?    
      @setState
        taskKey: @getCurrentSubject().type 
        viewBox: [0, 0, @getCurrentSubject().width, @getCurrentSubject().height]     

  # Handle user selecting a pick/drawing tool:
  handleDataFromTool: (d) ->
    classifications = @state.classifications
    currentClassification = classifications[@state.classificationIndex]

    currentClassification.annotation[k] = v for k, v of d

    @forceUpdate()
    @setState classifications: classifications, => @forceUpdate()

  handleTaskComplete: (d) ->
    @handleDataFromTool(d)
    if @state.subject_id
      @setState
        subject_id: null
      @commitClassificationAndContinue(d, @_fetchByProps)
    else
      @commitClassificationAndContinue d      
    
  toggleTutorial: ->
    @setState showingTutorial: not @state.showingTutorial

  hideTutorial: ->
    @setState showingTutorial: false

  toggleHelp: ->
    @setState helping: not @state.helping

  render: ->
    currentAnnotation = @getCurrentClassification().annotation

    onFirstAnnotation = currentAnnotation?.task is @getActiveWorkflow().first_task
    <div>
         { if ! @getCurrentSubject()?
             <section className="row align-justify toolbar">
               <div className="columns align-center label-title">
                 <div className="transcribe-instructions small-12">
                   <br/>
                   Currently, there are no labels for you to verify. Try <a href="/mark">marking</a> instead!
                   <br/><br/>
                 </div>
               </div>
             </section>

          else if @getCurrentSubject()?
            
            <SubjectViewer
               onLoad={@handleViewerLoad}
               subject={@getCurrentSubject()}
               active=true
               workflow={@getActiveWorkflow()}
               viewBox={@state.viewBox}                          
               classification={@props.classification}
               annotation={currentAnnotation}>
                 
              { if ( VerifyComponent = @getCurrentTool() )?

                <VerifyComponent
                  viewerSize={@state.viewerSize}
                  task={@getCurrentTask()}
                  annotation={@getCurrentClassification().annotation}
                  onShowHelp={@toggleHelp if @getCurrentTask().help?}
                  badSubject={@state.badSubject}
                  onBadSubject={@toggleBadSubject}
                  subject={@getCurrentSubject()}
                  onChange={@handleTaskComponentChange}
                  onComplete={@handleTaskComplete}
                  workflow={@getActiveWorkflow()}
                  project={@props.project}
                />
              }
            </SubjectViewer>
        }
      </div>

window.React = React
