module InfinityTest
  class Application
    include InfinityTest::TestLibrary
    include InfinityTest::ApplicationLibrary
    include Notifiers
    
    attr_accessor :config, :watchr, :global_commands

    # Initialize the Application object with the configuration instance to
    # load configuration and set properly
    #
    def initialize
      @config = InfinityTest.configuration
      @watchr = InfinityTest.watchr
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

    # Return a instance of the test framework class
    #
    def test_framework
      @test_framework ||= setting_test_framework
    end

    # Return true if the application is using Test::Unit
    # Return false otherwise
    #
    def using_test_unit?
      test_framework.instance_of?(TestUnit)
    end
    
    # Return a instance of the app framework class
    #
    def app_framework
      @app_framework ||= setting_app_framework
    end

    # Return all the Heuristics of the application
    #
    def heuristics
      config.instance_variable_get(:@heuristics)
    end

    # Triggers the #add_heuristics! method in the application_framework
    #
    def add_heuristics!
      app_framework.add_heuristics!
    end

    def heuristics_users_high_priority!
      @watchr.rules.reverse!
    end

    # Return the app_watch directory pattern
    #
    def app_directory_pattern
      app_framework.app_watch_path if app_framework
    end

    # Pass many commands(expecting something that talk like Hash) and run them
    # First, triggers all the before each callbacks, run the commands
    # and last, triggers after each callbacks
    #
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

    # Construct the Global Commands and cache for all suite
    #
    def global_commands
      @global_commands ||= construct_commands
    end

    # Run the global commands
    #
    def run_global_commands!
      run!(global_commands)
    end

    # Return the notification_framework setting in the configuration file
    # Maybe is: :growl, :lib_notify
    #
    def notification_framework
      config.notification_framework
    end

    # Send the message,image and the actual ruby version to show in the notification system
    #
    def notify!(options)
      if notification_framework
        message = parse_results(options[:results])
        title = options[:ruby_version]
        send(notification_framework).title(title).message(message).image(image_to_show).notify!
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

    # Return the files that match by the options
    # This very used in the #run method called in the heuristics instances
    #
    # Example:
    #
    #  files_to_run!(:all => :files) # => Return all test files
    #  files_to_run!(:all => :files, :in_dir => :models) # => Return all the test files in the models directory
    #  files_to_run!(:test_for => match_data)  # => Return the tests that match with the MatchData Object
    #  files_to_run!(:test_for => match_data, :in_dir => :controllers) # => Return the tests that match with the MatchData Object
    #  files_to_run!(match_data) # => return the test file
    #
    def files_to_run!(options)
      return options.to_s if options.is_a?(MatchData)
      if options.equal?(:all) or options.include?(:all)
        search_files_in_dir(all_test_files, :in_dir => options[:in_dir]).join(' ')
      else
        search_file(:pattern => options[:test_for][1], :in_dir => options[:in_dir]) if options.include?(:test_for)
      end
    end

    # Search files under the dir(s) specified
    #
    def search_files_in_dir(files, options)
      dirs = [options[:in_dir]].compact.flatten
      match_files = dirs.collect do |directory|
         files.select { |file| file.match(directory.to_s) }
      end
      match_files.empty? ? files : match_files
    end
    
    # Search files that matches with the pattern
    #
    def search_file(options)
      files = all_test_files.grep(/#{options[:pattern]}/i)
      search_files_in_dir(files, :in_dir => options[:in_dir]).join(' ')
    end

    # Return all the tests files in the User application
    #
    def all_test_files
      test_framework.all_files
    end

    # Run commands for a file
    # If dont have a file, do nothing
    #
    def run_commands_for_file(file)
      if file and !file.empty?
        commands = test_framework.construct_commands(file)
        run!(commands)
      end
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
        Rails.new
      when :rubygems
        RubyGems.new
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
