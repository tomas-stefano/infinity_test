
require 'infinity_test'

require 'watchr'

RSpec.configure do |config|
        
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
    application_with(:test_framework => :rspec)
  end

  def application_with_test_unit
    application_with(:test_framework => :test_unit)
  end
  
  def application_with_rails
    application_with(:app_framework => :rails)
  end
  
  def application_with_rubygems
    application_with(:app_framework => :rubygems)
  end
  
  def application_with_growl
    application = InfinityTest::Application.new
    application.config.notifications :growl
    application
  end
  
  def new_application(options)
    application = InfinityTest::Application.new
    application.config.notifications options[:notifications] if options[:notifications]
    application.config.use(options) if options
    application
  end
  
  def continuous_testing_with(application)
    InfinityTest::ContinuousTesting.new(:application => application)
  end
  
  def image(basename)
    File.expand_path(File.join(File.dirname(__FILE__), '..', 'images', basename))
  end
  
  def custom_image(basename)
    File.expand_path(File.join(File.dirname(__FILE__), 'factories', basename))
  end
  
  def custom_image_dir
    File.expand_path(File.join(File.dirname(__FILE__), 'factories', 'images'))
  end
  
  def run_the_command(app)
    command = mock(InfinityTest::Command)
    command.should_receive(:results).at_least(:once).and_return('0 examples, 0 failures')
    app.should_receive(:say_the_ruby_version_and_run_the_command!).at_least(:once).and_return(command)
    app.should_receive(:notify!).and_return(nil)
    app.run!(['spec'])
  end
  
  def factory_company_gemfile
    File.expand_path(File.join(File.dirname(__FILE__), 'factories', 'company', 'Gemfile'))
  end
  
  def factory_buzz_gemfile
    File.expand_path(File.join(File.dirname(__FILE__), 'factories', 'buzz', 'Gemfile'))
  end
  
  def current_env
    RVM::Environment.current
  end
  
  def environment_name
    current_env.environment_name
  end
  
  def application_with_gemfile(application)
    application.should_receive(:have_gemfile?).and_return(true)
    application.should_receive(:skip_bundler?).and_return(false)
  end
  
  def application_without_gemfile(application)
    application.should_receive(:have_gemfile?).and_return(false)
  end
end

  
RSpec::Matchers.define :have_pattern do |expected|
  match do |heuristics|
    heuristics.patterns.should have_key(expected)
  end
end
