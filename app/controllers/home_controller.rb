class HomeController < ApplicationController
  before_filter :require_allowed_ip!
  
  def index
    @projects = @scrumninja.projects.find_all { |p| @project_map.keys.include? p.name.downcase } 
    @projects.each do |project|
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
