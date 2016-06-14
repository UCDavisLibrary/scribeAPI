class Admin::DashboardController < Admin::AdminBaseController

  def index
    project = Project.current
    limit = 5
    page = get_int :page, 1

    # Verify items
    @verifies = Subject.page(page).per(limit).active_non_root.by_workflow(Workflow.where(:name=>"verify").first.id)

    # Filter on labels that are not Approved
    retired_subject_ids = Subject.root.retired().map{|s| s.subject_set_id }
    approvables = Subject.active_non_root.where(:subject_set_id.nin => retired_subject_ids,
                                              :workflow => Workflow.where(:name=>"verify").first.id)

    approvable_map = {}
    for subject in approvables
      approvable_map[subject.subject_set_id] = subject
    end
    @approves = Kaminari.paginate_array(approvable_map.values)
    @stats = project.calc_stats
  end

  def recalculate_stats
    project = Project.current
    project.check_and_update_stats
    render :json => {:project => project, :stats => project.stats}
  end
end
