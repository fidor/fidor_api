require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default do
  system('bundle exec rspec')
  system('bundle exec rubocop')
end
