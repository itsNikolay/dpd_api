# encoding: UTF-8

require "bundler/gem_tasks"
require 'rubygems'

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'bundler'
require 'rake'
require 'rspec/core/rake_task'

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec)

task :default => [:spec]
