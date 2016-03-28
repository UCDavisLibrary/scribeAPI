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
        <div className="top-bar-left">
          <ul className="menu">
            <li>
              <Link to="/" activeClassName="selected">Label This</Link>
            </li>          
            <li>
              <Link to="/browse/1" activeClassName="selected">Browse</Link>
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
               <a href="">Search</a>
             </li>
          </ul>
        </div>
        <div className="top-bar-right">
          <ul className="menu">
            <li>
              <a href="">About the Project</a>
            </li>
            <li>
              <a target="_blank" href="">Blog</a>
            </li>
          </ul>
        </div>
      </nav>
    </header>
