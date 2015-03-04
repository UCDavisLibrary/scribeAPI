# @cjsx React.DOM
React          = require 'react'
SubjectViewer  = require '../subject-viewer'
tasks          = require '../tasks'
Classification = require 'models/classification'
{fetchSubjects}  = require 'lib/fetchSubjects'


# NOTES: "mark" subjects should be fetched somewhere in here

module.exports = React.createClass # rename to Classifier
  displayName: 'Mark'

  propTypes:
    workflow: React.PropTypes.object.isRequired

  getInitialState: ->
    workflow:    @props.workflow
    currentTask: @props.workflow.tasks[@props.workflow.first_task]
    # classification: new Classification subject

  componentDidMount: ->
    subjects = fetchSubjects "/workflows/#{@state.workflow.id}/subjects.json?limit=5"
    @setState 
      subjects:       subjects
      currentSubject: subjects[0] 
    
  render: ->
    console.log 'taskType: ', @state.taskType
    TaskComponent = tasks[@state.currentTask.tool]
    
    <div className="classifier">
      <div className="subject-area">
      </div>
      <div className="task-area">
        <div className="task-container">
          <TaskComponent task={@state.currentTask} annotation={null} onChange={null} />
          <hr/>
          <nav className="task-nav">
            <button type="button" className="back minor-button" disabled={false}>Back</button>
            { if nextTaskKey?
                <button type="button" className="continue major-button" disabled={false} onClick={null}>Next</button>
              else
                <button type="button" className="continue major-button" disabled={false} onClick={null}>Done</button>
            }
          </nav>
        </div>
      </div>
    </div>

window.React = React
