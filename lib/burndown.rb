module ScrumNinja::Burndown
  def get_project_burndown(project)
    burndown = {}
    project.card_wall = @scrumninja.project_card_wall project.id 
    project.sprints = @scrumninja.project_sprints project.id
    
    project.card_wall = [] if project.card_wall.nil?
    project.sprints = [] if project.sprints.nil?
    
    start_date = project.sprints[0].starts_on.to_date
    end_date =  project.sprints[0].ends_on.to_date
    
    burndown[:start] = start_date.to_time.to_i * 1000
    burndown[:length] = (end_date - start_date).to_i + 1
    days_passed = (Date.today - start_date).to_i + 1
    # for each day in the sprint
    burndown[:estimates] = []
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
      burndown[:estimates] << total_hours
    end
    burndown
  end
end