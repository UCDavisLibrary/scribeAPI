React = require("react")
API                           = require '../lib/api'
Project                       = require 'models/project.coffee'
BrowserWarning                = require './browser-warning'

{RouteHandler}                = require 'react-router'

window.API = API

App = React.createClass
  getInitialState: ->
    routerRunning:        false
    user:                 null
    loginProviders:       []
    subjectsTotalResults: 0

  componentDidMount: ->
    @fetchUser()

  fetchUser:->
    @setState
      error: null
    request = $.getJSON "/current_user"

    request.done (result)=>
      if result?.data
        @setState
          user: result.data
      else

      if result?.meta?.providers
        @setState loginProviders: result.meta.providers

    request.fail (error)=>
      @setState
        loading:false
        error: "Having trouble logging you in"

  render: ->
    project = window.project
    return null if ! project?

    style = {}
    style.backgroundImage = "url(#{project.background})" if project.background?

    <div>

        <div>
          <BrowserWarning />
          <RouteHandler hash={window.location.hash} project={project} user={@state.user}/>
        </div>

    </div>

module.exports = App
