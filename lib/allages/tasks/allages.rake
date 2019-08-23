require 'rails/generators'
require 'pry'

namespace :allages do

  desc 'Initialize allages'
  task :init => :environment do
    puts defined?(Rails) ? "Rails exists" : "No rails"
    binding.pry
    Rails::Generators.invoke 'plain_init'
  end

  desc 'Generate changelog'
  task :generate => :environment do
    Allages.generate
  end

  desc 'Create new version'
  task :new_version => :environment do
    Allages.new_version
  end

  desc 'Create new entry'
  task :new_entry => :environment do
    Allages.new_entry
  end

end