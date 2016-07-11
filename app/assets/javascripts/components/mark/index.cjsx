React                   = require 'react'
{Navigation}            = require 'react-router'
SubjectViewer           = require 'components/subject-viewer'
SubjectSetViewer = require 'components/subject-set-viewer'
coreTools               = require 'components/core-tools'
FetchSubjectSetsMixin   = require 'lib/fetch-subject-sets-mixin'
SubjectSetToolbar       = require 'components/subject-set-toolbar'
BaseWorkflowMethods     = require 'lib/workflow-methods-mixin'
JSONAPIClient           = require 'json-api-client' # use to manage data?
API                     = require '../../lib/api'
HelpModal               = require 'components/help-modal'
Tutorial                = require 'components/tutorial'
HelpButton              = require 'components/buttons/help-button'
BadSubjectButton        = require 'components/buttons/bad-subject-button'
DraggableModal          = require 'components/draggable-modal'
Draggable               = require 'lib/draggable'
{Link}                  = require 'react-router'
ZoomPanListenerMethods        = require 'lib/zoom-pan-listener-methods'

module.exports = React.createClass # rename to Classifier
  displayName: 'Mark'

  getDefaultProps: ->
    workflowName: 'mark'
    type: 'root'

  mixins: [FetchSubjectSetsMixin, BaseWorkflowMethods, Navigation] # load subjects and set state variables: subjects, currentSubject, classification

  getInitialState: ->
    taskKey:             null
    classifications:     []
    classificationIndex: 0
    subject_set_index:   0
    subject_index:       0
    currentSubToolIndex: 0
    helping:             false
    hideOtherMarks:      false
    currentSubtool:      null
    showingTutorial:     false
    lightboxHelp:        false
    activeSubjectHelper: null
    subjectCurrentPage:  1

  componentDidMount: ->
    @getCompletionAssessmentTask()
    @fetchSubjectSetsBasedOnProps()
    @fetchGroups()  # FIXME maybe remove this code? LD

  componentWillMount: ->
    @setState taskKey: @getActiveWorkflow().first_task
    @beginClassification()

  componentDidUpdate: (prev_props) ->
    # If visitor nav'd from, for example, /mark/[some id] to /mark, this component won't re-mount, so detect transition here:
    if prev_props.hash != @props.hash
      @fetchSubjectSetsBasedOnProps()

  toggleHelp: ->
    @setState helping: not @state.helping
    @hideSubjectHelp()

  toggleTutorial: ->
    @setState showingTutorial: not @state.showingTutorial

  toggleLightboxHelp: ->
    @setState lightboxHelp: not @state.lightboxHelp
    @hideSubjectHelp()

  toggleHideOtherMarks: ->
    @setState hideOtherMarks: not @state.hideOtherMarks

  # User changed currently-viewed subject:
  handleViewSubject: (index) ->
    @setState subject_index: index, => @forceUpdate()
    @toggleBadSubject() if @state.badSubject

  # User somehow indicated current task is complete; commit current classification
  handleToolComplete: (annotation) ->
    # LD - removing this code as we only have one type of tool (rect) and we don't need this distinction
    #
    # @handleDataFromTool(annotation)
    #
    if annotation.override_task_key?
      @setState
         taskKey: annotation.override_task_key, =>
           @createAndCommitClassification(annotation)
    else
      @createAndCommitClassification(annotation)

  # Handle user selecting a pick/drawing tool:
  handleDataFromTool: (d) ->
    # Kind of a hack: We receive annotation data from two places:
    #  1. tool selection widget in right-col
    #  2. the actual draggable marking tools
    # We want to remember the subToolIndex so that the right-col menu highlights
    # the correct tool after committing a mark. If incoming data has subToolIndex
    # but no mark location information, we know this callback was called by the
    # right-col. So only in that case, record currentSubToolIndex, which we use
    # to initialize marks going forward
    if d.subToolIndex? && ! d.x? && ! d.y?
      @setState currentSubToolIndex: d.subToolIndex
      @setState currentSubtool: d.tool if d.tool?

    else
      classifications = @state.classifications
      classifications[@state.classificationIndex].annotation[k] = v for k, v of d

      # PB: Saving STI's notes here in case we decide tools should fully
      #   replace annotation hash rather than selectively update by key as above:
      # not clear whether we should replace annotations, or append to it --STI
      # classifications[@state.classificationIndex].annotation = d #[k] = v for k, v of d

      @setState
        classifications: classifications
          , =>
            @forceUpdate()

  handleMarkDelete: (m) ->
    @flagSubjectAsUserDeleted m.subject_id

  handleZoomUI: (viewBox) ->
    # accept changes to the viewbox and update accordingly
    @setState zoomedViewBox: viewBox

  destroyCurrentClassification: ->
    classifications = @state.classifications
    classifications.splice(@state.classificationIndex,1)
    @setState
      classifications: classifications
      classificationIndex: classifications.length-1

    # There should always be an empty classification ready to receive data:
    @beginClassification()

  completeSubjectSet: ->
    @commitCurrentClassification()
    @beginClassification()

    # TODO: Should maybe make this workflow-configurable?
    show_subject_assessment = true
    if show_subject_assessment
      @setState
        taskKey: "completion_assessment_task"

  completeSubjectAssessment: (callback_fn) ->
    @commitCurrentClassification()
    @beginClassification()
    @advanceToNextSubject(callback_fn)

  showSubjectHelp: (subject_type) ->
    @setState
      activeSubjectHelper: subject_type
      helping: false
      showingTutorial: false
      lightboxHelp: false

  hideSubjectHelp: () ->
    @setState
      activeSubjectHelper: null

  render: ->
    return null unless @getCurrentSubjectSet()? && @getActiveWorkflow()?

    currentTask = @getCurrentTask()

    TaskComponent = @getCurrentTool()
    activeWorkflow = @getActiveWorkflow()
    firstTask = activeWorkflow.first_task
    onFirstAnnotation = @state.taskKey == firstTask
    currentSubtool = if @state.currentSubtool then @state.currentSubtool else @getTasks()[firstTask]?.tool_config.tools?[0]

    # direct link to this page
    pageURL = "#{location.origin}/mark?subject_set_id=#{@getCurrentSubjectSet().id}&selected_subject_id=#{@getCurrentSubject()?.id}"

    if currentTask?.tool is 'pick_one'
      currentAnswer = (a for a in currentTask.tool_config.options when a.value == currentAnnotation.value)[0]
      waitingForAnswer = not currentAnswer


    <div>
      <section className="row align-justify toolbar">
        <SubjectSetToolbar
          workflow={@getActiveWorkflow()}
          task={currentTask}
          subject={@getCurrentSubjectSet()?.subjects?[0]}
          lightboxHelp={@togglelightboxHelp}
          hideOtherMarks={@state.hideOtherMarks}
          handleZoomUI={@handleZoomUI}
          toggleHideOtherMarks={@toggleHideOtherMarks}
          />
        <div className="columns align-center label-title">
          <div className="mark-instructions small-12">
            <h1>Instructions:</h1>
            <p><small>Draw a box around an area of interest on this label. Then tell us whether what you’ve marked is an image or text.
            <br/><em>Need help? <a onClick={@toggleTutorial}>Watch a tutorial.</a></em></small></p>
          </div>
        </div>
        <a className="secondary button next-label" disabled={waitingForAnswer} onClick={() => @advanceToNextSubject()}>Next<img className="right-pointer" src="/images/right-pointer-red.svg"/></a>
      </section>
     { if @state.noMoreSubjectSets
         <p>There is nothing left to do. Thanks for your work and please check back soon!</p>

       else if @state.notice
         <DraggableModal header={@state.notice.header} onDone={@state.notice.onClick}>{@state.notice.message}</DraggableModal>

       else if @getCurrentSubjectSet().subjects?

         <SubjectSetViewer
         subject_set={@getCurrentSubjectSet()}
         subject_index={@state.subject_index}
         workflow={@getActiveWorkflow()}
         task={currentTask}
         annotation={@getCurrentClassification()?.annotation ? {}}
         onComplete={@handleToolComplete}
         onChange={@handleDataFromTool}
         onDestroy={@handleMarkDelete}
         onViewSubject={@handleViewSubject}
         subToolIndex={@state.currentSubToolIndex}
         subjectCurrentPage={@state.subjectCurrentPage}
         totalSubjectPages={@state.subjects_total_pages}
         destroyCurrentClassification={@destroyCurrentClassification}
         hideOtherMarks={@state.hideOtherMarks}
         toggleHideOtherMarks={@toggleHideOtherMarks}
         currentSubtool={currentSubtool}
         lightboxHelp={@toggleLightboxHelp}
         zoomedViewBox={@state.zoomedViewBox}
         interimMarks={@state.interimMarks}
         />

        }
        { if @state.showingTutorial
         <Tutorial workflow={@getActiveWorkflow()} onCloseTutorial={@toggleTutorial} />
        }
    </div>
