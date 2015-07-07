require 'model_strength'
require 'rails'

module ModelStrength
  class Railtie < Rails::Railtie
    railtie_name :model_strength

    rake_tasks do
      load 'tasks/model_strength_tasks.rake'
    end
  end
end
