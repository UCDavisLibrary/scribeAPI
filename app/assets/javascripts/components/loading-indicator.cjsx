# @cjsx React.DOM

React = require 'react'

LoadingIndicator = React.createClass
  displayName: 'LoadingIndicator'

  render: ->
    <div className="loading-indicator">
      Loading...
    </div>

module.exports = LoadingIndicator
