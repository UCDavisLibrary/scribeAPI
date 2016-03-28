React = require 'react'

Footer = React.createClass
  displayName: 'Footer'

  propTypes:->
    privacyPolicy: @props.privacyPolicy

  getInitialState: ->
    categories: null
    
  render: ->
          
    <footer>
      <section className="row align-spaced">
        <div><a href="https://www.lib.ucdavis.edu">UC Davis Library</a></div>
        <div><a href="https://www.lib.ucdavis.edu/dept/specol/">Special Collections</a></div>
        <div><a href="https://give.ucdavis.edu/ulib/">Support the Library</a></div>
      </section>
      <section className="row align-spaced">
        <div><p>University of California, Davis, One Shields Avenue, Davis, CA 95616 | 530-752-1011</p></div>
      </section>
      <section className="row align-spaced">
        <div><a href="https://www.ucdavis.edu/help">Help</a></div>
        <div><a href="https://www.ucdavis.edu/contact">Questions or comments?</a></div>
        <div><a href="https://www.ucdavis.edu/privacy-and-accessibility">Privacy & Accessibility</a></div>
        <div><a href="http://occr.ucdavis.edu/poc/">Principles of Community</a></div>
        <div><a href="http://www.universityofcalifornia.edu/">University of California</a></div>
      </section>
      <section className="row align-spaced">
       <p>Copyright &copy; The Regents of the University of California, Davis campus. All rights reserved.</p>
      </section>
    </footer>
        
module.exports = Footer

