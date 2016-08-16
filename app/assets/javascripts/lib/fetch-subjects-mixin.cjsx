API = require './api'

module.exports =
  componentDidMount: ->
    @_fetchByProps()

  _fetchByProps: ->
    # Fetching a single subject?
    if @props.identifier? or @props.params.identifier
      @fetchSubjectByIdentifier @props.identifier or @props.params.identifier

    else if @state.subject_id?
      @fetchSubject @state.subject_id


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
        status:                   @props.status ? null
        random:                   @props.show_in_random_order ? false
      @fetchSubjects params

  orderSubjectsByY: (subjects) ->
    subjects.sort (a,b) ->
      return if a.region.y >= b.region.y then 1 else -1

  # Fetch by identifier
  fetchSubjectByIdentifier: (identifier) ->
    request = API.type("labels").get identifier
    request.then (subject) =>
      # Get any Marks that match this subject
      _params = {
        workflow_id: @getActiveWorkflow?().id
        subject_set_id: subject.subject_set_id
        status: "active"
      }
      marks = API.type("subjects").get(_params).then (subjects) =>
        if subjects.length is 0
          # Redirect the user to the /view endpoint for this identifier
          location.href = '/view/' + identifier
        else
          @setState
            subjects_next_page: subjects[0].getMeta("next_page")
            subjects_prev_page: subjects[0].getMeta("prev_page")
            subjects: subjects,
              () =>
                if @fetchSubjectsCallback?
                  @fetchSubjectsCallback()


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
        if @props.browse or not subjects.region?
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
