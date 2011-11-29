require 'cucumber/rake/task'
require 'rspec/core/rake_task'

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

desc "Run all RSpec examples"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--tag ~performance"
end

desc "Run perfomance tests"
RSpec::Core::RakeTask.new(:performance) do |t|
  t.rspec_opts = "--tag performance"
end
