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

require 'watchr'

  def stub_home_config(options)
    File.should_receive(:expand_path).with('~/.infinity_test').and_return(options[:file])
  end
  
  def read_and_load_home_config(options)
    stub_home_config :file => options[:file]
    @application.load_configuration_file
  end
  
  def application_with(options)
    application = InfinityTest::Application.new
    application.config.use(options)
    application
  end
  
  def application_with_rspec
    application = InfinityTest::Application.new
    application.config.use(:test_framework => :rspec)
    application
  end

  def application_with_test_unit
    application = InfinityTest::Application.new
    application.config.use(:test_framework => :test_unit)
    application
  end
  
  def image(basename)
    File.expand_path(File.join(File.dirname(__FILE__), '..', 'images', basename))
  end
  