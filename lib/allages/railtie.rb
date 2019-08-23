require 'rails'
require 'rails/generators'
require 'allages'
require 'generators/init_generator'
require 'generators/config_generator'

module Allages
  class Railtie < Rails::Railtie
    railtie_name :allages

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end