class SessionsController < Devise::SessionsController
  layout "admin"
  # LD removed original code and just subclassed from the parent here
end
