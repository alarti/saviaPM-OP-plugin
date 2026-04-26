module OpenProject
  module AiProjectPlanner
    class Engine < ::Rails::Engine
      engine_name :openproject_ai_project_planner

      include OpenProject::Plugins::ActsAsOpEngine

      register(
        'openproject-ai_project_planner',
        author_url: 'https://github.com/opf/openproject',
        requires_openproject: '>= 12.0.0'
      )

      # Register the Improvement Hook for the UI
      # We add a "Project Advisor" button/hook within the Project Overview and Work Package views
      initializer 'ai_project_planner.register_hooks' do
        ActiveSupport.on_load(:action_controller) do
          require 'open_project/ai_project_planner/hooks'
        end
      end
    end
  end
end
