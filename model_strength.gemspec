$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "model_strength/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ModelStrength"
  s.version     = ModelStrength::VERSION
  s.authors     = ["David Dérus"]
  s.email       = ["david.derus@kasual.biz"]
  s.homepage    = "http://gitlab.kasual.biz/dderus/model_strength"
  s.summary     = "Add strength to your model, in order to evaluate completeness."
  s.description = "Evaluate completeness by adding a score to your model, as Linkedin do with its Profile Strength."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.2"

  s.add_development_dependency "sqlite3"
end
