module AiProjectPlanner
  class AnalysisController < ApplicationController
    before_action :find_project_by_project_id
    before_action :authorize

    ##
    # @brief Analyzes project deviations and returns suggestions.
    # @author Alberto Arce
    #
    def analyze
      advisor = OptimizationAdvisorService.new(@project)
      result = advisor.call

      # We can save this result to our new DB model if we want to store history
      Suggestion.create!(
        project: @project,
        description: "Automated analysis run on #{Time.current}",
        suggested_changes: result
      )

      respond_to do |format|
        format.html { render plain: result.to_json, content_type: 'application/json' }
        format.json { render json: result }
      end
    end
  end
end
