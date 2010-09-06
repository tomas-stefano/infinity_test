require 'rubygems'
require 'infinity_test'

rvm_library_directory = File.expand_path("~/.rvm/lib")
$LOAD_PATH.unshift(rvm_library_directory) unless $LOAD_PATH.include?(rvm_library_directory)
require 'rvm'

begin
  require 'spec'
rescue LoadError
  require 'rspec'
end

  def stub_home_config(options)
    file = File.should_receive(:expand_path).with('~/.infinity_test').and_return(options[:file])
  end
  
  def read_and_load_home_config(options)
    stub_home_config :file => options[:file]
    @application.load_configuration_file
  end
  
  def application_with(options)
    application = InfinityTest::Application.new
    application.config.run_with(options)
    application
  end
  
  def application_with_rspec
    application = InfinityTest::Application.new
    application.config.run_with(:test_framework => :rspec)
    application
  end

  def application_with_test_unit
    application = InfinityTest::Application.new
    application.config.run_with(:test_framework => :test_unit)
    application
  end