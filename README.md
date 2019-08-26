# Allages

#### What Allages is?

This gem was created to help maintain a changelog in a project.

It can be used as a standalone utility for any kind of application or embedded as a gem in a RoR project.

Allages generates a markdown changelog based on the keepachangelog.com format.

"Allages" translates to "changes" in greek.

#### So, why not use a simple markdown file?

Keeping a changelog file for an application with many collaborators is hard due to conflicts that often occur. In order to avoid this messy situation, a directory based approach, with changes contained in their own file each, is a better alternative. No conflicts arise when merging feature/hotfix branches. Also, by using a simple script, one can generate a single CHANGELOG.md file by simply parsing the directory structure for entries.

The directory tree convention that  looks like this (sample):

```
  changelogs
  ├── 1.0.3
  │   └── d4fe5be8-7237-4b40-854a-0e09f38be8ae.yml
  ├── 1.0.4
  │   ├── 531985ac-f3b4-4ba4-a257-31dabfdd9200.yml
  │   └── bf701293-1620-4997-a728-3a50342407b8.yml
  └── Unreleased
      ├── 50267ff1-1047-4302-9843-19eeb79deea2.yml
      └── d4fe5be8-7237-4b40-854a-0e09f38be8ae.yml
```

each subfolders under the /changelogs folder is considered a version. "Unreleased" is by convention the folder to keep all the new changelog entries that have not yet made it into a version.

Each yaml file is a changelog entry. The name of the file has no effect on the entry description. If you use the handy rake task in order to create the entry, then a uuid named file is created which helps with resolving accidental conflicts. But you are free to use any other naming scheme, if you like. What is inside the yaml files is what matters:

```
date: 2019-08-22
type: Added
description: This is a nice addition to our app
author: Tolis
issue: 11
dependencies:
  - ~> backend-1.0.2
  - -> solr-5.5
```

The above is a typical changelog entry.

By using the markdown generator we get something like this:

```
# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased
### Added
- Another nice addition
### Fixed
- This was a bug, it is now fixed, issue: 67

## 1.0.3
### Fixed
- This was a bug, it is now fixed, issue: 67

## 1.0.4
### Added
- This is a nice addition to our app, issue: 11, dependencies: ~> backend-1.0.2, -> solr-5.5
### Changed
- This was wrong, so we changed it, issue: 89
```


## Installation

##### For RoR projects

Add this line to your application's Gemfile:

```ruby
gem 'allages'
```

And then execute:

    $ bundle

##### For all other projects

    $ gem install allages


And generate the default tree structure with:

##### For RoR projects

```
$ rails generate allages:init
      create  config/initializers/allages.rb
      create  changelogs
      create  changelogs/Unreleased
```

##### For all other projects

```
$ allages init
      create  .allages.yml
      create  changelogs
      create  changelogs/Unreleased
```

You can change the default allages configuration in your rails app.


##### For RoR projects

... by using an initializer. Like so:
```
Allages.configure do |config|
  config.input_dir = 'changelogs'
  config.output_file = :stdout
  config.include_unreleased = true
  config.header = <<~END
  # Changelog
  All notable changes to this project will be documented in this file.

  The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
  and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

  END
end
```

##### For all other projects

by editing the settings in the generated .allages.yml file:
```
input_dir: 'changelogs'
output_file: 'CHANGELOG.md'
include_unreleased: false
header: |+
  # Changelog
  All notable changes to this project will be documented in this file.

  The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
  and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


```


## Usage

### Creating a new (unreleased) entry

Just invoke the proper rake task with:
##### For RoR projects

```
$ rake allages:new_entry
```
##### For all other projects

```
$ allages new_entry
```
And by giving the proper entry data:
```
Type (a)dded, (c)hanged, (f)ixed, (d)eprecated, (r)emoved, (s)ecurity: a
Description: This is something new
Author: Tolis
Issue: 90
Dependencies (comma seperated): one dep, then another one
created new unreleased entry changelogs/Unreleased/f062f1cc-0d97-461f-928f-5c108c406d3f.yml
```
a new yaml file will created in the changelogs/Unreleased directory.

### Creating a new version

Creating a new version section for our changelog is as easy as creating a directory with the version name within /changelogs. But you can use a rake task for that:
##### For RoR projects
```
$ rake allages:new_version
```
##### For all other projects
```
$ allages new_version
```
```
Version name: 1.0.4
created directory changelogs/1.0.4
```
By using the rake task you get a aditional hidden .meta.yml file within the created directory. This is for storing extra metadata (date, dependencies) regarding this version. You can edit this file manually. The extra metadata will be included in the version header of the generated markdown file. Leave the yaml values commented out if you don't want any metadata on your version descriptions.

### Generating the CHANGELOG.md

As expected, there's a rake task for that:
##### For RoR projects
```
$ rake allages:generate
```
##### For all other projects
```
$ allages generate
```
The markdown will be output on the console if the reserved `:stdout` keyword is used, or in a file if a string was given in the configuration.

### Version metadata

By putting a .meta.yml file in the version folder you can add metadata such as date and dependencies in your changelog version/section headers:

```
date: 2019-08-22
dependencies:
  - dependency 1
  - dependency 2
```
Then the version header generated will look like this:
```
## 1.0.4 - 2019-08-22 - dependencies: dependency 1, dependency 2
```

## TODO

* A rake task to move entries from Unrealased to a new version
* Write tests
* Break the rails dependency

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/allages. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Allages project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/allages/blob/master/CODE_OF_CONDUCT.md).
