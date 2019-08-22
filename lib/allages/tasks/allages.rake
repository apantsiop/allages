namespace :allages do

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