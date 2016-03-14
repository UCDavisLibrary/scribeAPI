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
          <li className="menu-text">
             <Link to="/" activeClassName="selected">
              {
                unless @props.logo?
                  @props.short_title
                else
                  <img src={@props.logo} />
               }
             </Link>
          </li>
          {
            # Workflows tabs:
            workflow_names = ['transcribe','mark','browse']
            workflows = (w for w in @props.workflows when w.name in workflow_names)
            workflows = workflows.sort (w1, w2) -> if w1.order > w2.order then 1 else -1
            workflows.map (workflow, key) =>
              title = workflow.name.charAt(0).toUpperCase() + workflow.name.slice(1)
              <li key={key}><Link to="/#{workflow.name}" activeClassName="selected">{title}</Link></li>
          }
          { # Page tabs, check for main menu
            if @props.menus? && @props.menus.main?
              for item, i in @props.menus.main
                <li key={item.page or i}>
                if item.page?
                  <Link to="/#{item.page}" activeClassName="selected">{item.label}</Link>
                else if item.url?
                  <a href="#{item.url}">{item.label}</a>
                else
                  <a>{item.label}</a>
                </li>
            # Otherwise, just list all the pages in default order
            else
              @props.pages?.map (page, key) =>
                formatted_name = page.name.replace("_", " ")
                <li key={key}>
                  <Link to="/#{page.name.toLowerCase()}" activeClassName="selected">{formatted_name}</Link>
                </li>
                  
          }

          { # include feedback tab if defined
            showFeedbackTab = false
            if @props.feedbackFormUrl? and showFeedbackTab
              <li><a href={@props.feedbackFormUrl}>Feedback</a></li>
          }
          { # include blog tab if defined
            if @props.blogUrl?
              <li><a target={"_blank"} href={@props.blogUrl}>Blog</a></li>
          }
          { # include blog tab if defined
            if @props.discussUrl?
              <li><a target={"_blank"} href={@props.discussUrl}>Discuss</a></li>
          }
          </ul>
        </nav>
    </header>
