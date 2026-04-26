module AiProjectPlanner
  ##
  # @brief Service to analyze project progress and suggest optimizations.
  # @author Alberto Arce
  #
  class OptimizationAdvisorService
    ##
    # @brief Initializes the service with a specific project context.
    # @param project [Project] The project to analyze.
    #
    def initialize(project)
      @project = project
    end

    ##
    # @brief Analyzes cost entries and work packages to identify deviations.
    # @return [Hash] A hash containing suggestions and deviations found.
    #
    def call
      deviations = analyze_deviations
      suggestions = generate_suggestions(deviations)

      {
        deviations: deviations,
        suggestions: suggestions
      }
    end

    private

    ##
    # @brief Analyzes the project's work packages to find time/cost deviations.
    # @return [Array<Hash>] List of deviations identified.
    #
    def analyze_deviations
      deviations = []

      # We simulate reading from cost_entries and work_packages
      # In OpenProject, TimeEntry represents spent time
      @project.work_packages.includes(:time_entries).each do |wp|
        spent_hours = wp.time_entries.sum(:hours)
        estimated_hours = wp.estimated_hours.to_f

        if estimated_hours > 0 && spent_hours > estimated_hours
          deviations << {
            work_package_id: wp.id,
            subject: wp.subject,
            type: 'time_overrun',
            estimated: estimated_hours,
            spent: spent_hours,
            diff: spent_hours - estimated_hours
          }
        end

        # Delay detection: due date passed but not closed
        if wp.due_date && wp.due_date < Date.today && !wp.closed?
          deviations << {
            work_package_id: wp.id,
            subject: wp.subject,
            type: 'schedule_delay',
            due_date: wp.due_date,
            days_late: (Date.today - wp.due_date).to_i
          }
        end
      end

      deviations
    end

    ##
    # @brief Generates actionable suggestions based on identified deviations.
    # @param deviations [Array<Hash>] List of identified deviations.
    # @return [Array<String>] Human-readable suggestions.
    #
    def generate_suggestions(deviations)
      suggestions = []

      if deviations.empty?
        suggestions << "The project is on track. No immediate optimizations needed."
        return suggestions
      end

      deviations.each do |dev|
        case dev[:type]
        when 'time_overrun'
          suggestions << "Work Package ##{dev[:work_package_id]} ('#{dev[:subject]}') has exceeded estimated time by #{dev[:diff]} hours. Consider reviewing remaining effort and adjusting the Gantt chart."
        when 'schedule_delay'
          suggestions << "Work Package ##{dev[:work_package_id]} ('#{dev[:subject]}') is delayed by #{dev[:days_late]} days. Propose adjusting successor task dates to mitigate bottleneck."
        end
      end

      suggestions
    end
  end
end
