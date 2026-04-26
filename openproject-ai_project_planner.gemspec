$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require_relative "lib/open_project/ai_project_planner/version" if File.exist?(File.expand_path("lib/open_project/ai_project_planner/version.rb"))

Gem::Specification.new do |s|
  s.name        = "openproject-ai_project_planner"
  s.version     = "1.0.0"
  s.authors     = ["Alberto Arce"]
  s.email       = ["alberto.arce@example.com"]
  s.homepage    = "https://github.com/opf/openproject"
  s.summary     = "OpenProject AI Project Planner"
  s.description = "Generates project structures based on text descriptions and provides an optimization advisor."
  s.license     = "GPL-3.0"

  s.files = Dir["{app,config,db,lib}/**/*", "CHANGELOG.md", "README.md"]

  s.add_dependency "rails", ">= 6.1"
end
