$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'aws_utils'
require 'pry'
require 'rspec/expectations'

def require_dependencies
  `pwd`
  ['lib'].each do |folder|
    puts "Folder: #{folder}"
    Dir.glob(File.join("./", "#{folder}", "**", "*.rb")) do |file|
      puts "\tFile: #{file}"
      require file
    end
  end
end

def before_each_spec(config)
  config.before(:each) { |s|
    puts "\nRunning spec: '#{s.example_group.metadata[:full_description]}'"
    $validation_errors = []
    Loader.initialize
  }
end

def after_each_spec(config)
  config.after(:each) {
    if !$validation_errors.empty?
      msg = "Spec failed. # of validation errors: #{$validation_errors.size}"
      $validation_errors.each do |error|
        msg += "\n\t" + error
      end
      $validation_errors.clear
      raise StandardError.new("Boom! #{msg}")
    end
  }
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = false
  before_each_spec(config)
  after_each_spec(config)
end

require_dependencies
$time = Time.now
$validation_errors=[]

puts "Running tests at #{$time} against: #{$env}"