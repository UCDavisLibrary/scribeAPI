
# @cjsx React.DOM
React                   = require 'react'
{Navigation}            = require 'react-router'
SubjectViewer           = require '../subject-viewer'
JSONAPIClient           = require 'json-api-client' # use to manage data?
FetchSubjectsMixin      = require 'lib/fetch-subjects-mixin'
BaseWorkflowMethods     = require 'lib/workflow-methods-mixin'

# Hash of core tools:
coreTools               = require 'components/core-tools'

# Hash of transcribe tools:
transcribeTools         = require './tools'

RowFocusTool            = require '../row-focus-tool'
API                     = require '../../lib/api'

HelpModal               = require 'components/help-modal'
Tutorial                = require 'components/tutorial'
DraggableModal          = require 'components/draggable-modal'
GenericButton           = require 'components/buttons/generic-button'

module.exports = React.createClass # rename to Classifier
  displayName: 'Transcribe'
  mixins: [FetchSubjectsMixin, BaseWorkflowMethods, Navigation] # load subjects and set state variables: subjects,  classification

  getInitialState: ->
    taskKey:                      null
    classifications:              []
    classificationIndex:          0
    subject_index:                0
    helping:                      false
    last_mark_task_key:           @props.query.mark_key
    showingTutorial:              false

  getDefaultProps: ->
    workflowName: 'transcribe'
    status: 'active'
    show_in_random_order: false

  componentWillMount: ->
    @beginClassification()

  fetchSubjectsCallback: ->
    if @getCurrentSubject()?
      identifier = @getCurrentSubject()['meta_data'].identifier
      historyState = {subject: identifier}
      if window.history.state?['subject'] != identifier
        window.history.pushState(historyState, '', '/transcribe/' + identifier)
      @setState
        taskKey: @getCurrentSubject().type

  # Handle user selecting a pick/drawing tool:
  handleDataFromTool: (d) ->
    classifications = @state.classifications
    currentClassification = classifications[@state.classificationIndex]

    # this is a source of conflict. do we copy key/value pairs, or replace the entire annotation? --STI
    currentClassification.annotation[k] = v for k, v of d

    @setState
      classifications: classifications,
        => @forceUpdate()

  handleTaskComplete: (d) ->
    @handleDataFromTool(d)
    @commitClassificationAndContinue d

  handleViewerLoad: (props) ->
    @setState
      viewerSize: props.size

    if (tool = @refs.taskComponent)?
      tool.onViewerResize props.size

  makeBackHandler: ->
    () =>
      console.log "go back"

  toggleHelp: ->
    @setState helping: not @state.helping

  toggleTutorial: ->
    @setState showingTutorial: not @state.showingTutorial

  # transition back to mark workflow
  returnToMarking: ->
    @transitionTo 'mark', {},
      subject_set_id: @getCurrentSubject().subject_set_id
      selected_subject_id: @getCurrentSubject().parent_subject_id
      mark_task_key: @props.query.mark_key
      subject_id: @getCurrentSubject().id

      page: @props.query.page

  render: ->
    if @props.params.workflow_id? and @props.params.parent_subject_id?
      transcribeMode = 'page'
    else if @props.params.subject_id
      transcribeMode = 'single'
    else
      transcribeMode = 'random'

    if @state.subjects?
      isLastSubject = ( @state.subject_index >= @state.subjects.length - 1 )
    else isLastSubject = null



    currentAnnotation = @getCurrentClassification().annotation
    TranscribeComponent = @getCurrentTool() # @state.currentTool
    onFirstAnnotation = currentAnnotation?.task is @getActiveWorkflow().first_task

    <div>
      <section className="row align-justify toolbar">
          <div className="columns align-center label-title">
            <div className="transcribe-instructions small-12">
              {
                if @state.noMoreSubjects
                  <div>
                    <br/>
                    Currently, there are no labels for you to transcribe. Try <a href="/mark">marking</a> instead!
                    <br/><br/>
                  </div>
                else
                  <div>
                    <h1>Instructions:</h1>
                      <p><small>Tell us what the highlighted text says, or describe the highlighted image.
                      <br/><em>Need help? <a onClick={@toggleTutorial}>Watch a tutorial.</a></em></small></p>
                  </div>
              }
            </div>
          </div>
          {
            if not @state.noMoreSubjects and @getCurrentSubject()
              <a className="secondary button next-label" onClick={@advanceToNextSubject}>Next<img className="right-pointer" src="../../images/right-pointer-red.svg"/></a>
          }
       </section>
        {
          if @getCurrentSubject()? and @getCurrentTask()? and not @state.noMoreSubjects

            <SubjectViewer
              onLoad={@handleViewerLoad}
              task={@getCurrentTask()}
              subject={@getCurrentSubject()}
              active=true
              workflow={@getActiveWorkflow()}
              classification={@props.classification}
              annotation={currentAnnotation}
            >
              <TranscribeComponent
                viewerSize={@state.viewerSize}
                annotation_key={"#{@state.taskKey}.#{@getCurrentSubject().id}"}
                key={@getCurrentTask().key}
                task={@getCurrentTask()}
                annotation={currentAnnotation}
                subject={@getCurrentSubject()}
                onChange={@handleDataFromTool}
                subjectCurrentPage={@props.query.page}
                onComplete={@handleTaskComplete}
                onBack={@makeBackHandler()}
                workflow={@getActiveWorkflow()}
                viewerSize={@state.viewerSize}
                transcribeTools={transcribeTools}
                onShowHelp={@toggleHelp if @getCurrentTask().help?}
                badSubject={null}
                onBadSubject={null}
                illegibleSubject={@state.illegibleSubject}
                onIllegibleSubject={@toggleIllegibleSubject}
                returnToMarking={@returnToMarking}
                transcribeMode={transcribeMode}
                isLastSubject={isLastSubject}
                project={@props.project}
                inputType="textarea"
              />

            </SubjectViewer>
        }

      { if @getCurrentTask()? and @getCurrentSubject()
          nextTask =
            if @getCurrentTask().tool_config.options?[currentAnnotation.value]?
              @getCurrentTask().tool_config.options?[currentAnnotation.value].next_task
            else
              @getCurrentTask().next_task
      }
      { if @state.showingTutorial
         <Tutorial workflow={@getActiveWorkflow()} onCloseTutorial={@toggleTutorial} />
      }

    </div>

window.React = React
