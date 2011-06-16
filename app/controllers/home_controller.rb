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
      project.card_wall = @scrumninja.project_card_wall project.id 
      project.sprints = @scrumninja.project_sprints project.id
      
      project.stories = [] if project.stories.nil?
      project.card_wall = [] if project.card_wall.nil?
      project.sprints = [] if project.sprints.nil?
      
      start_date = project.sprints[0].starts_on.to_date
      end_date =  project.sprints[0].ends_on.to_date
      
      project.sprint_start = start_date.to_time.to_i * 1000 + (24 * 3600 * 1000)
      project.sprint_length = (end_date - start_date).to_i
      days_passed = (Date.today - start_date).to_i + 1
      # for each day in the sprint
      project.backlog = []
      days_passed.times do |i|
        start_time = (start_date + i).to_time
        end_time = (start_date + i + 1).to_time
        total_hours = 0
        project.card_wall.each do |task|
          if task.created_at < end_time
            if task.done_at.nil? or task.done_at > end_time
              # we have a task that counts towards today, dig into estimates
              if task.estimates.estimate.is_a? Array then
                estimate_hours = 0
                task.estimates.estimate.each do |estimate|
                  estimate_day = estimate.date.to_date
                  break if(estimate_day.to_time > end_time)
                  estimate_hours = task.estimates.estimate[0].hours.to_f
                end
                total_hours += estimate_hours
              else
                total_hours += task.estimates.estimate.hours.to_f
              end
            end
          end
        end
        project.backlog << total_hours
      end
    end
  end
  
  def backlog
    @backlog = @scrumninja.project_backlog(params[:project_id])
  end

  def submit
  end
  
  private 
  
  def add_estimate(project,est)
    stamp = Date.parse(est.date).to_time.to_i * 1000
    project.estimates[stamp] = 0 if project.estimates[stamp].nil?
    project.estimates[stamp] = project.estimates[stamp] + est.hours.to_f
  end
  
end
