class HomeController < ApplicationController
  def index
    @projects = ScrumNinja.projects('c17bafe18ce469e3a4300873de284dc24e3fcb78')
    @projects.each do |project|
      project.stories = ScrumNinja.project_stories('c17bafe18ce469e3a4300873de284dc24e3fcb78',project.id)
      project.card_wall = ScrumNinja.project_card_wall('c17bafe18ce469e3a4300873de284dc24e3fcb78',project.id)
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
end
