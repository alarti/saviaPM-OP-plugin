class CreateAiProjectPlannerSuggestions < ActiveRecord::Migration[6.1]
  def change
    create_table :ai_project_planner_suggestions do |t|
      t.references :project, null: false, foreign_key: true, index: true
      t.text :description
      t.json :suggested_changes

      t.timestamps
    end
  end
end
