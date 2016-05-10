class Admin::DashboardController < Admin::AdminBaseController
  
  def index
    project = Project.current
    limit = 30
    page = get_int :page, 1
    
    # Verify items
    @verifies = Subject.page(page).per(limit).where(:workflow => Workflow.where(:name=>"verify").first.id)
    @stats = project.calc_stats
  end

  def recalculate_stats
    project = Project.current
    project.check_and_update_stats
    render :json => {:project => project, :stats => project.stats}
  end
end
