class Admin::DashboardController < Admin::AdminBaseController

  def index
    project = Project.current
    limit = 5
    page = get_int :page, 1

    # Items that are in the Verify workflow and have no child subjects
    @verifies = Subject.page(page).per(limit).active_non_root.by_workflow(Workflow.where(:name=>"verify").first.id).where(:secondary_subject_count => 0)

    # Filter on labels that are not Approved but all Verified children have secondary subjects
    retired_subject_ids = Subject.root.retired().map{|s| s.subject_set_id }
    approvables = Subject.where(:subject_set_id.nin => retired_subject_ids).or({type: "consensus_image"}, {type: "consensus_text"})
    approvable_map = {}
    for subject in approvables
      related_subjects = Subject.by_subject_set(subject.parent_subject.subject_set_id).by_workflow(Workflow.where(:name=>"verify").first.id).where(:secondary_subject_count => 0)
      if related_subjects.count == 0
        approvable_map[subject.subject_set_id] = subject
      end
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
