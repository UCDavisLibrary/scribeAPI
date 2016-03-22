React = require("react")
{Link} = require 'react-router'
Router = require 'react-router'
# {Navigation, Link} = Router
Login = require '../components/login'

module.exports = React.createClass
  displayName: 'MainHeader'

  getDefaultProps: ->
    user: null
    loginProviders: []

  render: ->
    <header>

      <nav className="top-bar">
        <ul className="menu">
          <li>
            <Link to="/#" activeClassName="selected">Label This</Link>
          </li>          
          <li>
            <Link to="browse" activeClassName="selected">Browse</Link>
          </li>
          {
            # Workflows tabs:
            workflow_names = ['transcribe','mark']
            workflows = (w for w in @props.workflows when w.name in workflow_names)
            workflows = workflows.sort (w1, w2) -> if w1.order > w2.order then 1 else -1
            workflows.map (workflow, key) =>
              title = workflow.name.charAt(0).toUpperCase() + workflow.name.slice(1)
              <li key={key}><Link to="/#{workflow.name}" activeClassName="selected">{title}</Link></li>
          }
          <li>
            <Link to="/#about" activeClassName="selected">About the Project</Link>
          </li>
          { # include blog tab if defined
            if @props.blogUrl?
              <li><a target={"_blank"} href={@props.blogUrl}>Blog</a></li>
          }
          </ul>
        </nav>
    </header>
