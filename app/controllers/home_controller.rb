class HomeController < ApplicationController
  before_filter :require_granicus_ip!
  
  def index
    @projects = @scrumninja.projects
    @projects.each do |project|
      project.stories = @scrumninja.project_stories(project.id)
      project.card_wall = @scrumninja.project_card_wall(project.id)
      project.stories = [] if project.stories.nil?
      project.card_wall = [] if project.card_wall.nil?
      project.stories.each do |story|
        story.tasks = [];
        project.card_wall.each do |task|
          if(task.story_id == story.id) then
            story.tasks << task
          end
        end
        total = 0;
        completed = 0;
        story.tasks.each do |task|
          total = total + 1
          completed = completed + 1 if task.status == "done"
        end
        story.total_tasks = total;
        story.completed_tasks = completed;
        story.completed_percent = (total == 0) ? 0 : ((completed.to_f / total.to_f) * 100).floor
      end
    end
  end
  
  def backlog
    @backlog = @scrumninja.project_backlog(params[:project_id])
  end

  def submit
  end

end
