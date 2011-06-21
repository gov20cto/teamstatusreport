class HomeController < ApplicationController
  before_filter :require_allowed_ip!
  
  def index
    @projects.each do |project|
      next unless @project_map.keys.include? project.name.downcase
      project.estimates = []
      project.stories = @scrumninja.project_stories project.id
       
      project.stories = [] if project.stories.nil?
      project.burndown = @scrumninja.project_burndown project.id
    end
  end
  
  def backlog
    @backlog = @scrumninja.project_backlog(params[:project_id])
  end

  def submit
  end
  
end
