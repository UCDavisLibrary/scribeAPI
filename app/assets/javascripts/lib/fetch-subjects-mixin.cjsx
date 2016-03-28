API = require './api'

module.exports =
  componentDidMount: ->
    @_fetchByProps()

  _fetchByProps: ->
    # Fetching a single subject?
    if @props.params?.subject_id?
      @fetchSubject @props.params.subject_id

    # Fetching subjects by current workflow and optional filters:
    else
      # Gather filters by which to query subjects
      params =
        parent_subject_id:        @props.params?.parent_subject_id ? null
        group_id:                 @props.query?.group_id ? null
        subject_set_id:           @props.query?.subject_set_id ? null
        page:                     @props.params?.page ? @props.page ? 1
        limit:                    @props.limit ? @getActiveWorkflow?().subject_fetch_limit
        order_filter:             @props.params?.order_filter ? null
        type:                     @props.type ? null
      @fetchSubjects params
    
  orderSubjectsByY: (subjects) ->
    subjects.sort (a,b) ->
      return if a.region.y >= b.region.y then 1 else -1

  # Fetch a single subject:
  fetchSubject: (subject_id)->
    request = API.type("subjects").get subject_id

    request.then (subject) =>
      @setState
        subject_index: 0
        subjects: [subject],
        () =>
          if @fetchSubjectsCallback?
            @fetchSubjectsCallback()

  fetchSubjects: (params, callback) ->

    _params = $.extend({
      workflow_id: @getActiveWorkflow?().id
    }, params)
    
    API.type('subjects').get(_params).then (subjects) =>
      if subjects.length is 0
        @setState noMoreSubjects: true

      else
        if @props.browse
          @setState subjects: subjects          
        else
          @setState subjects: @orderSubjectsByY(subjects)
          
        @setState
          subject_index: 0
          subjects_next_page: subjects[0].getMeta("next_page")
          subjects_prev_page: subjects[0].getMeta("prev_page")
          subjects_total_results: subjects[0].getMeta("total")  
          subjects_current_page: subjects[0].getMeta("current_page")
          subjects_total_pages: subjects[0].getMeta("total_pages")
                    
      # Does including instance have a defined callback to call when new subjects received?
      if @fetchSubjectsCallback?
        @fetchSubjectsCallback()


 
