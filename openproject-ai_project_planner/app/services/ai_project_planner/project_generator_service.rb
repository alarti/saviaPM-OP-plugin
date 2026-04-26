require 'json'

module AiProjectPlanner
  ##
  # @brief Service to orchestrate the creation of a project from AI-parsed data.
  # @author Alberto Arce
  #
  class ProjectGeneratorService
    ##
    # @brief Main entry point to create a project from a description.
    # @param description [String] The raw text input from the user (assumed to be a JSON string here).
    # @return [Project] The newly created OpenProject project object.
    #
    def call(description)
      data = parse_description(description)

      ActiveRecord::Base.transaction do
        project = create_project(data['project'])
        versions = create_versions(project, data['phases'])
        create_work_packages_and_relations(project, versions, data['tasks'])

        project
      end
    end

    private

    ##
    # @brief Parses the input description.
    # @param description [String] JSON string representing project data.
    # @return [Hash] Parsed data.
    #
    def parse_description(description)
      JSON.parse(description)
    rescue JSON::ParserError
      raise StandardError, "Invalid JSON description format"
    end

    ##
    # @brief Creates the main project instance using Projects::CreateService.
    # @param project_data [Hash] Attributes for the project.
    # @return [Project] Created project.
    #
    def create_project(project_data)
      result = Projects::CreateService.new(
        user: User.current
      ).call(project_data)

      raise StandardError, "Project creation failed: #{result.errors.full_messages.join(', ')}" unless result.success?

      result.result
    end

    ##
    # @brief Creates versions (phases) for the project.
    # @param project [Project] The project to add versions to.
    # @param phases_data [Array<Hash>] Data for versions.
    # @return [Hash] Mapping of phase name to Version object.
    #
    def create_versions(project, phases_data)
      versions = {}
      phases_data&.each do |phase|
        version = Version.create!(
          project: project,
          name: phase['name'],
          description: phase['description'],
          start_date: phase['start_date'],
          effective_date: phase['end_date'] # often used as end_date in OP
        )
        versions[phase['id']] = version
      end
      versions
    end

    ##
    # @brief Creates work packages and sets up WBS (parent_id) and Gantt relations.
    # @param project [Project] The project context.
    # @param versions [Hash] Mapping of phase id to Version.
    # @param tasks_data [Array<Hash>] Task data including hierarchy and relations.
    # @return [void]
    #
    def create_work_packages_and_relations(project, versions, tasks_data)
      work_packages = {}

      # First pass: Create Work Packages
      tasks_data&.each do |task|
        wp_params = {
          subject: task['subject'],
          description: task['description'],
          type_id: task['type_id'], # e.g., Phase, Task, Milestone
          project_id: project.id,
          estimated_hours: task['estimated_hours'],
          start_date: task['start_date'],
          due_date: task['due_date'],
          author: User.current
        }

        wp_params[:version_id] = versions[task['phase_id']].id if task['phase_id'] && versions[task['phase_id']]

        result = WorkPackages::CreateService.new(
          user: User.current
        ).call(wp_params)

        raise StandardError, "Work Package creation failed: #{result.errors.full_messages.join(', ')}" unless result.success?

        work_packages[task['id']] = result.result
      end

      # Second pass: Set up WBS (parent_id)
      tasks_data&.each do |task|
        if task['parent_id'] && work_packages[task['parent_id']]
          wp = work_packages[task['id']]
          wp.update!(parent_id: work_packages[task['parent_id']].id)
        end
      end

      # Third pass: Set up Gantt Relations (predecessors/followers)
      tasks_data&.each do |task|
        task['predecessors']&.each do |pred_id|
          if work_packages[pred_id]
            Relation.create!(
              from: work_packages[pred_id],
              to: work_packages[task['id']],
              relation_type: Relation::TYPE_PRECEDES
            )
          end
        end
      end
    end
  end
end
