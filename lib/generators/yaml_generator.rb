require 'rails/generators/base'

module Allages
  class YamlGenerator < Rails::Generators::Base
    desc "This generator initializes the allages gem with this directory"

    def create_initializer_file
      create_file ".allages.yml", <<~CONFIG
      # input_dir: 'changelogs'
      # output_file: 'stdout'
      # include_unreleased: false
      # header: |+
      #   # Changelog
      #   All notable changes to this project will be documented in this file.
      #
      #   The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
      #   and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
      #
      CONFIG
    end

    def create_directories_structure
      empty_directory Allages.config.input_dir
      empty_directory "#{Allages.config.input_dir}/Unreleased"
    end
  end
end