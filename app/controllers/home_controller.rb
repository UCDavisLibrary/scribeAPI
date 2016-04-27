class HomeController < BrowseController
  caches_action :index, :cache_path => "home/index"

end
