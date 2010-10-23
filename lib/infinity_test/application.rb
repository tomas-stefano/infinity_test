module InfinityTest
  class Application
    include InfinityTest::Notifications
    include InfinityTest::TestLibrary

    attr_accessor :config, :library_directory_pattern

    # Initialize the Application object with the configuration instance to
    # load configuration and set properly
    #
    def initialize
      @config = InfinityTest.configuration
      @library_directory_pattern = "^lib/*/(.*)\.rb"
    end

    # Load the Configuration file
    #
    #
    # Command line options can be persisted in a .infinity_test file in a project. 
    # You can also store a .infinity_test file in your home directory (~/.infinity_test) with global options. 
    #
    # Precedence is:
    # command line
    # ./.infinity_test
    # ~/.infinity_test
    #
    # Example:
    #
    #  ~/.infinity_test -> infinity_test { notifications :growl }
    #
    #  ./.infinity_test -> infinity_test { notifications :lib_notify }  # High Priority
    #
    # After the load the Notifications Framework will be Lib Notify
    #
    def load_configuration_file
      load_global_configuration    # Separate global and local configuration
      load_project_configuration   # because it's more easy to test
    end

    # Return the sucess image to show in the notifications
    #
    def sucess_image
      config.sucess_image
    end

    # Return the failure image to show in the notifications
    #
    def failure_image
      config.failure_image
    end

    # Return the pending image to show in the notifications
    #
    def pending_image
      config.pending_image
    end

    # Return the block object setting in the config file
    #
    def before_callback
      config.before_callback
    end

    # Return the block object setting in the config file
    #
    def before_environment_callback
      config.before_environment_callback
    end

    # Return the block object setting in the config file
    #
    def after_callback
      config.after_callback
    end

    # Return the block object setting in the before(:each_ruby) block
    #
    def before_each_ruby_callback
      config.before_each_ruby_callback
    end

    # Return the block object setting in the after(:each_ruby) block
    #
    def after_each_ruby_callback
      config.after_each_ruby_callback
    end

    # Return the rubies setting in the config file or the command line
    #
    def rubies
      config.rubies
    end

    # Return true if verbose mode is on
    # Verbose mode is false as default
    #
    def verbose?
      config.verbose
    end
    
    # Return true if the user application has a Gemfile
    # Return false if not exist the Gemfile
    #
    def have_gemfile?
      File.exist?(gemfile)
    end

    # Return false if you want the InfinityTest run with bundler
    # Return true otherwise
    #
    def skip_bundler?
      config.skip_bundler?
    end

    # Contruct all the commands for the test framework
    #
    def construct_commands
      test_framework.construct_commands
    end

    # Return the test directory pattern setting in the .infinity_test file
    #
    def test_directory_pattern
      test_framework.test_directory_pattern
    end

    # Return a instance of the test framework class
    #
    def test_framework
      @test_framework ||= setting_test_framework
    end

    #Return a instance of the app framework class
    #
    def app_framework
      @app_framework ||= setting_app_framework
    end

    #Return the app_watch directory pattern
    #
    def app_directory_pattern
      app_framework.app_watch_path if app_framework
    end

    # Return a instance of the Notification Framework class
    #
    def notification_framework
      @notification_framework ||= setting_notification
    end

    def run_before_environment_callback!
      before_environment_callback.call(self) if before_environment_callback
    end

    def run!(commands)
      before_callback.call if before_callback

      commands.each do |ruby_version, command|
        call_each_ruby_callback(:before_each_ruby_callback, ruby_version)
        command = say_the_ruby_version_and_run_the_command!(ruby_version, command) # This method exist because it's more easier to test
        notify!(:results => command.results, :ruby_version => ruby_version)
        call_each_ruby_callback(:after_each_ruby_callback, ruby_version)
      end

      after_callback.call if after_callback
    end

    # Send the message,image and the actual ruby version to show in the notification system
    #
    def notify!(options)
      if notification_framework
        message = parse_results(options[:results])
        notification_framework.notify(:title => options[:ruby_version], :message => message, :image => image_to_show)
      else
        # skip(do nothing) when not have notification framework
      end
    end

    # Parse the results for each command to the test framework
    #
    # app.parse_results(['.....','108 examples']) # => '108 examples'
    #
    def parse_results(results)
      test_framework.parse_results(results)
    end

    # If the test pass, show the sucess image
    # If is some pending test, show the pending image
    # If the test fails, show the failure image
    #
    def image_to_show
      if test_framework.failure?
        failure_image
      elsif test_framework.pending?
        pending_image
      else
        sucess_image
      end
    end

    # After change the file the infinity_test will search a similar file to run
    #
    def run_changed_app_file(file)
      test_files=app_framework.test_files_for(file.to_s)
      puts test_files
      run_commands_for_file(test_files.join(' ')) unless test_files.empty?
    end
    
    def run_changed_lib_file(file)
      file = File.basename(file[1])
      files = test_framework.all_files.grep(/#{file}/i)
      run_commands_for_file(files.join(' ')) unless files.empty?
    end

    def run_changed_test_file(file)
      run_commands_for_file(file)
    end

    def run_commands_for_file(file)
      commands = test_framework.construct_commands(file)
      run!(commands)
    end

    private

    def call_each_ruby_callback(callback_type, ruby_version)
      callback = send(callback_type)
      callback.call(RVM::Environment.new(ruby_version)) if callback
    end

    def say_the_ruby_version_and_run_the_command!(ruby_version, command)
      puts; puts "* { :ruby => #{ruby_version} }"
      puts command if verbose?
      Command.new(:ruby_version => ruby_version, :command => command).run!
    end

    def setting_test_framework
      case config.test_framework
      when :rspec
        Rspec.new :rubies => rubies
      when :test_unit
        TestUnit.new :rubies => rubies
      when :bacon
        Bacon.new :rubies => rubies
      end
    end

    def setting_app_framework
      case config.app_framework 
      when :rails
        Rails.new :test_framework => test_framework
      end
    end

    def setting_notification
      case config.notification_framework
      when :growl
        Growl.new
      when :lib_notify
        LibNotify.new
      end
    end

    def load_global_configuration
      load_file(File.expand_path('~/.infinity_test'))
    end

    def load_project_configuration
      load_file('./.infinity_test')
    end

    def load_file(file)
      load(file) if File.exist?(file)
    end
    
    def gemfile
      File.join(Dir.pwd, 'Gemfile')
    end

  end
end
