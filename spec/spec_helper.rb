require 'rubygems'
require 'bundler/setup'

require 'subclass_and_replace'
require 'pry'


Dir[File.join(File.dirname(__FILE__),"support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|

end