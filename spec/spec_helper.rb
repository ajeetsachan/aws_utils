$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'aws_utils'
require 'pry'
require 'rspec/expectations'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
# Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

def require_dependencies
  `pwd`
  ['lib'].each do |folder|
    puts "foldeR: #{folder}"
    Dir.glob(File.join("./", "#{folder}", "**", "*.rb")) do |file|
      puts "file: #{file}"
      require file
    end
  end
end

def before_each_spec(config)
  config.before(:each) { |s|
    puts "\nRunning spec: '#{s.example_group.metadata[:full_description]}'"
    Utils.load_and_sanitize("input-data")
    $validation_errors = []
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