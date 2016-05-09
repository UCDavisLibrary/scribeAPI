class Admin::DashboardController < Admin::AdminBaseController
  
  def index
    project = Project.current
    @stats = project.calc_stats
  end

  def recalculate_stats
    project = Project.current
    project.check_and_update_stats
    render :json => {:project => project, :stats => project.stats}
  end
end
