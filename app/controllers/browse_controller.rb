class BrowseController < ApplicationController

  # LD Some of these values are duplicated in browse-panel.cjxs and subjects_controller.rb, sorry
  def index
    limit = 30
    page = get_int :page, 1
    @subjects = Subject.by_type("root").page(page).per(limit)
  end

  def view
    identifier = params[:identifier]

    subjects, @link = BrowseMethods.browse_by_identifier(identifier)
    @subject = subjects[0]
  end

  def metadata
    identifier = params[:identifier]

    subjects = BrowseMethods.get_by_identifier(identifier)
    @subject = subjects[0]
    render layout: false
  end

end
