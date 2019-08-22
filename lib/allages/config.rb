module Allages

  def self.configure(&block)
    yield @config ||= Allages::Configuration.new
  end

  def self.config
    @config
  end

  class Configuration
    attr_accessor :input_dir, :output_file, :include_unreleased, :header
  end

  def self.reset_config
    self.configure do |config|
      config.input_dir = 'changelogs'
      config.output_file = :stdout
      config.include_unreleased = false
      config.header = <<~END
      # Changelog
      All notable changes to this project will be documented in this file.

      The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
      and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

      END
    end
  end

  reset_config()

end