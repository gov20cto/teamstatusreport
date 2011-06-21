class HomeController < ApplicationController
  before_filter :require_allowed_ip!
  
  def index
    @projects = @scrumninja.projects
    @projects.each do |project|
      next unless @project_map.keys.include? project.name.downcase
      project.estimates = []
      project.stories = @scrumninja.project_stories project.id
       
      project.stories = [] if project.stories.nil?
      project.burndown = @scrumninja.project_burndown project.id
      project.burndown = Hashie::Mash.new if project.burndown.nil?
      project.burndown.estimates = [] if project.burndown.estimates.nil?
    end
  end
  
  def backlog
    @backlog = @scrumninja.project_backlog(params[:project_id])
  end

  def submit
  end
  
end
