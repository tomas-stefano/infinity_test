
require 'infinity_test'
require 'watchr'
# require 'simplecov'
# SimpleCov.start do
#   add_filter '/spec'
#   add_filter './.infinity_test'
# end

RSpec.configure do |config|

  def stub_application_with_rspec
    InfinityTest.stub!(:application).and_return(application_with_rspec)
  end

  def stub_application_with_test_unit
    InfinityTest.stub!(:application).and_return(application_with_test_unit)
  end

  def application_with(options)
    application = InfinityTest::Application.new
    application.config.use(options)
    InfinityTest.stub(:application).and_return(application)
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
    @current_env ||= RVM::Environment.current
  end

  def environment_name
    @environment_name ||= current_env.environment_name
  end

  def application_with_gemfile(application)
    application.should_receive(:have_gemfile?).and_return(true)
    application.should_receive(:skip_bundler?).and_return(false)
  end

  def application_without_gemfile(application)
    application.should_receive(:have_gemfile?).and_return(false)
  end

  # Factories! Or Fixtures - Whathever

  def buzz_library(&block)
    factories_for('buzz', &block)
  end

  def wood_library(&block)
    factories_for('wood', &block)
  end

  def slinky_library(&block)
    factories_for('slinky', &block)
  end
  
  def rails_app(&block)
    factories_for('rails_app', &block)
  end
  
  def rubygems_lib(&block)
    factories_for('rubygems_lib', &block)
  end

  def factories_for(directory, &block)
    Dir.chdir("#{infinity_test_root}/spec/factories/#{directory}", &block)
  end

  def infinity_test_root
    File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end

end

RSpec::Matchers.define :have_pattern do |expected|
  match do |heuristics|
    heuristics.patterns.should have_key(expected)
  end
end
