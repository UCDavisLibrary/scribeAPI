React = require 'react'
{Navigation} = require 'react-router'
{Link} = require 'react-router'
SVGImage = require '../svg-image'
FetchSubjectsMixin = require 'lib/fetch-subjects-mixin'
SubjectMetadata = require '../subject-metadata'
{MarkDisplay, LabelDisplay} = require '../approve/tools'
MouseHandler = require 'lib/mouse-handler'

module.exports = React.createClass
  displayName: "ViewPanel"
  mixins: [Navigation, FetchSubjectsMixin]

  getDefaultProps: ->
    identifier: null
    showMarks: false
    mode: "view"

  getInitialState: ->
    subjects: []
    subjects_next_page: null
    subjects_prev_page: null

  componentWillReceiveProps: (newProps) ->
    if @props.identifier != newProps.identifier
      @fetchSubjectView newProps.identifier

  fetchSubjectsCallback: () ->
    if @props.showMarks
      for subject in @state.subjects
        @setState marks: @getMarksForSubject(subject)

#  selectMark: (e) ->
#    console.log(e)

  getMarksForSubject: (subject) ->
    # Previous marks are really just the region hashes of all child subjects
    marks = []
    for child_subject, i in subject.child_subjects
      continue if ! child_subject?
      marks[i] = child_subject.region
      marks[i].subject_id = child_subject.id # child_subject.region.subject_id = child_subject.id # copy id field into region (not ideal)

    marks

  renderMarks: (marks) ->
    return unless marks.length > 0
    # scale = @getScale()
    scale = 1.0

    marksToRender = for mark in marks
      <g key={mark._key}>
        <MarkDisplay
          key={mark._key}
          subject_id={mark.subject_id}
          taskKey={@props.task?.key}
          mark={mark}
          xScale={scale.horizontal}
          yScale={scale.vertical}
          disabled={! mark.userCreated}
          isTranscribable={mark.isTranscribable}
          interim={mark.interim_id?}
          isPriorMark={false}
          subjectCurrentPage={0}
          selected={false}
          getEventOffset={null}
          submitMark={null}
          sizeRect={{width: @state.subjects?[0].width, height: @state.subjects?[0].height}}
          displaysTranscribeButton={false}
          onChange={null}
          onDestroy={null}
        />
      </g>

    return marksToRender

  renderLabels: (marks) ->
    labelsToRender = for mark in marks
      <LabelDisplay mark={mark} key={mark._key}/>

  render: ->
    subject = @state.subjects?[0]
    if not subject
      return null

    viewBox = [0, 0, subject.width, subject.height]

    if @state.marks
      marksToRender = @renderMarks(@state.marks)
      labelsToRender = @renderLabels(@state.marks)

    if @state.subjects_prev_page
      prevButton = <Link className="secondary button previous-label" to={@state.subjects_prev_page}><img className="left-pointer" src="../../images/left-pointer-red.svg"/>Previous Label</Link>
    else
      prevButton = <span/>

    if @state.subjects_next_page
      nextButton = <Link className="secondary button next-label" to={@state.subjects_next_page}>Next Label<img className="right-pointer" src="../../images/right-pointer-red.svg"/></Link>
    else
      nextButton = <span/>

    return <div className="view">
        <section className="row align-justify toolbar">
          {prevButton}
          <div className="columns align-self-middle single label-title">Label { subject.meta_data.identifier }</div>
          {nextButton}
        </section>
        <section className="row align-center">
          <section className="column">
            <figure className="main-wine-label" key={subject.id}>
              <svg
                className = "subject-viewer-svg"
                viewBox={viewBox}
                >
                <SVGImage
                  src = {subject.location.standard}
                  width = {subject.width}
                  height = {subject.height} />
                {marksToRender}
              </svg>
              {labelsToRender}
            </figure>
          </section>
        </section>
        <SubjectMetadata subject={subject} key={subject.meta_data.identifier} />
      </div>
