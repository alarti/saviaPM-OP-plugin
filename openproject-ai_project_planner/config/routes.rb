OpenProject::Application.routes.draw do
  scope 'projects/:project_id', as: 'project' do
    namespace :ai_project_planner do
      get 'analysis', to: 'analysis#analyze'
    end
  end
end
