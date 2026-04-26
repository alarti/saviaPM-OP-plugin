module OpenProject
  module AiProjectPlanner
    # The Improvement Hook class that registers a menu item or a button
    # in the project_overview and work_package sidebars.
    class Hooks < ::Redmine::Hook::ViewListener
      ##
      # @brief Hook to inject Project Advisor button in project overview
      # @author Alberto Arce
      # @param context [Hash] Context of the current view
      # @return [String] HTML to be injected
      #
      def view_projects_show_left(context = {})
        project = context[:project]
        return '' unless project && User.current.allowed_in_project?(:view_work_packages, project)

        button_html(project)
      end

      ##
      # @brief Hook to inject Project Advisor button in work package view
      # @author Alberto Arce
      # @param context [Hash] Context of the current view
      # @return [String] HTML to be injected
      #
      def view_work_packages_show_details_bottom(context = {})
        project = context[:project] || context[:work_package]&.project
        return '' unless project && User.current.allowed_in_project?(:view_work_packages, project)

        button_html(project)
      end

      private

      def button_html(project)
        # Using OpenProject static routing helper (if accessible) or just emitting the angular component
        # We output a placeholder for our Angular component
        <<-HTML
          <div class="ai-project-planner-advisor-hook">
            <ai-project-advisor [projectId]="#{project.id}"></ai-project-advisor>
          </div>
        HTML
      end
    end
  end
end
