# encoding: utf-8

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'dpd_api'
require 'savon/mock/spec_helper'
require_relative 'support/rspec_helper'

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.include RspecHelper
end
