require 'rails/generators/base'

module Allages
  class InitGenerator < Rails::Generators::Base
    desc "This generator creates the nneded files for allages gem"

    def create_initializer_file
      create_file "config/initializers/allages.rb", <<~CONFIG
      Allages.configure do |config|
        # config.input_dir = 'changelogs'
        # config.output_file = :stdout
        # config.include_unreleased = false
        # config.header = <<~END
        # # Changelog
        # All notable changes to this project will be documented in this file.

        # The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
        # and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

        # END
      end
      CONFIG
    end

    def create_directories_structure
      empty_directory Allages.config.input_dir
      empty_directory "#{Allages.config.input_dir}/Unreleased"
    end
  end
end