class HomeController < ApplicationController
  before_filter :require_allowed_ip!
  
  def index
    @projects = @scrumninja.projects.find_all do |project| 
      if APP_CONFIG['ignore_projects'].is_a? String then
        !APP_CONFIG['ignore_projects'].split(',').include? project.id
      else 
        APP_CONFIG['ignore_projects'] != project.id
      end
    end
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
