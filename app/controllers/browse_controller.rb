class BrowseController < ApplicationController

  layout "nojs"

  # LD Some of these values are duplicated in browse-panel.cjxs and subjects_controller.rb, sorry
  def index
    limit = 30
    page = get_int :page, 1
    @subjects = Subject.page(page).per(limit).where(type: "root")
    
  end

  def view
    identifier = params[:identifier]
    
    subject, @link = BrowseMethods.show_by_identifier(identifier)
    @subject = subject[0]
  end
  
end
