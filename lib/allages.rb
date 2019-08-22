require "allages/version"
require "allages/config"
require "allages/railtie" if defined?(Rails)
require 'securerandom'

module Allages
  class Error < StandardError; end

  META_TEMPLATE = <<~META
  # date: #{Time.now.strftime('%F')}
  # dependencies:
  # - dependency 1
  # - dependency 2
  META

  def generate
    sections = []

    Dir.glob("#{Allages.config.input_dir}/*").each do |filename|
      if File.directory? filename
        section = {}
        dir = File.basename filename
        next if (dir == "Unreleased" && Allages.config.include_unreleased == false)
        section[:name] = dir

        if File.file? "#{filename}/.meta.yml"
          section[:meta] = YAML.load_file "#{filename}/.meta.yml"
        end

        categories = {}
        Dir.glob("#{filename}/*.yml").each do |entry_filename|
          next if entry_filename.match? /\.meta\.yml/
          entry = YAML.load_file entry_filename
          if categories.has_key? entry['type']
            categories[entry['type']] << entry
          else
            categories[entry['type']] = [entry]
          end
        end

        section[:categories] = categories
        sections << section
      end
    end

    sections.sort! do |a, b|
      if a[:name] == "Unreleased"
        -1
      elsif b[:name] == "Unreleased"
        1
      else
        a[:name] <=> b[:name]
      end
    end

    markdown = "#{Allages.config.header}"

    had_previous_section = false
    sections.each do |section|
      markdown << "\n" if had_previous_section
      had_previous_section = true
      title = ["## #{section[:name]}"]
      if section[:meta]
        title << section[:meta]['date'] if section[:meta]['date']
        title << "dependencies: #{section[:meta]['dependencies'].to_a.join(', ')}" unless section[:meta]['dependencies'].to_a.empty?
      end
      markdown << "#{title.join(' - ')}" << "\n"

      section[:categories].each do |category, entries|
        markdown << "### #{category}\n"

        entries.each do |entry|
          entry_md = [entry['description']]
          entry_md << "issue: #{entry['issue']}" if entry['issue']
          entry_md << "dependencies: #{entry['dependencies'].to_a.join(', ')}" unless entry['dependencies'].to_a.empty?
          markdown << "- #{entry_md.join(', ')}\n"
        end
      end
    end

    if Allages.config.output_file == :stdout
      puts markdown
    else
      open(Allages.config.output_file, 'w') do |f|
        f.puts markdown
      end
    end
  end

  module_function :generate

  def new_version
    print "Version name: "
    STDOUT.flush
    version = STDIN.gets.chomp
    dir = "#{Allages.config.input_dir}/#{version}"
    if File.directory?(dir)
      puts "version already exists"
      exit 1
    else
      FileUtils.mkdir_p(dir)
      puts "created directory #{dir} "
    end

    open("#{dir}/.meta.yml", 'w') do |f|
      f.puts META_TEMPLATE
    end
  end

  module_function :new_version

  def new_entry
    types = {
      "a" => "Added",
      "c" => "Changed",
      "f" => "Fixed",
      "d" => "Deprecated",
      "r" => "Removed",
      "s" => "Security"
    }

    print "Type (a)dded, (c)hanged, (f)ixed, (d)eprecated, (r)emoved, (s)ecurity: "
    STDOUT.flush
    type = types[STDIN.gets.chomp]

    print "Description: "
    STDOUT.flush
    description = STDIN.gets.chomp

    print "Author: "
    STDOUT.flush
    author = STDIN.gets.chomp

    print "Issue: "
    STDOUT.flush
    issue = STDIN.gets.chomp

    print "Dependencies (comma seperated): "
    STDOUT.flush
    deps = STDIN.gets.chomp.split(',').map{|d| "  - #{d.chomp.lstrip}"}.join("\n")

    yaml = <<~YAML
    date: #{Time.now.strftime('%F')}
    type: #{type}
    description: #{description}
    author: #{author}
    issue: #{issue}
    dependencies:
    #{deps}
    YAML

    filename = "#{SecureRandom.uuid}.yml"
    path = "#{Allages.config.input_dir}/Unreleased/#{filename}"

    open("#{path}", 'w') do |f|
      f.puts yaml
    end
    puts "created new unreleased entry #{path}"
  end

  module_function :new_entry
end
