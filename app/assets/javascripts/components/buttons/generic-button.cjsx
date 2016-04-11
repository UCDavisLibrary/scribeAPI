React             = require 'react'

module.exports = React.createClass
  displayName: 'GenericButton'

  getDefaultProps: ->
    label: 'Okay'
    disabled: false
    className: ''
    major: false
    onClick: null
    href: null

  render: ->
    onClick = @props.onClick

    if @props.href
      c = @props.onClick
      onClick = () =>
        c?()
        window.location.href = @props.href

    key = @props.href ? @props.onClick

    <button key={key} className="button #{@props.className}" onClick={onClick} disabled={if @props.disabled then 'disabled'}>
      { @props.label }
    </button>
