require 'cucumber/rake/task'

# adds build, install and release tasks
# for gem packaging
require "bundler/gem_tasks"


# defines a task named cucumber
# that runs all cucumber features
Cucumber::Rake::Task.new

desc "Run finished features"
Cucumber::Rake::Task.new(:finished) do |t|
  t.cucumber_opts = "--format progress --tags ~@wip"
end

desc "Run in-progress features"
Cucumber::Rake::Task.new(:wip) do |t|
  t.cucumber_opts = "--tags @wip"
end
