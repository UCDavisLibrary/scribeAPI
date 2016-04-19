class Browse::BrowseController < ApplicationController

  def index
    @subjects = Subject.where(type: "root")
  end
end
