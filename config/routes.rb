TeamStatusReport::Application.routes.draw do
  
  match '/backlog/:project_id' => 'home#backlog'
  root :to => "home#index"
  
end
