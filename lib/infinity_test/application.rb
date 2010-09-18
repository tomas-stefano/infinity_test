module InfinityTest
  class Application
    include Notifications
    
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
    # Load first global file in => ~/.infinity_test
    # After load the project file => ./.infinity_test
    #
    # If the Project file has the same methods in the global, will override the configurations
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
    
    def sucess_image
      config.sucess_image
    end
    
    def failure_image
      config.failure_image
    end
    
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
    
    # Return the rubies setting in the config file or the command line
    #
    def rubies
      config.rubies
    end
    
    def construct_commands
      test_framework.construct_commands
    end
    
    def test_directory_pattern
      test_framework.test_directory_pattern
    end
    
    # Return a instance of the test framework class
    #
    def test_framework
      @test_framework ||= setting_test_framework
    end
    
    # Return a instance of the Notification Framework class
    #
    def notification_framework
      @notification_framework ||= setting_notification
    end
    
    def run!(commands)
      before_callback.call if before_callback
      commands.each do |ruby_version, command|
        puts; puts "* { :ruby => #{ruby_version} }"
        puts command if verbose?
        command = Command.new(:ruby_version => ruby_version, :command => command).run!
        notify!(:results => command.results, :ruby_version => ruby_version)
      end
      after_callback.call if after_callback
    end
    
    def notify!(options)
      message = parse_results(options[:results])
      notification_framework.notify(:title => options[:ruby_version], :message => message, :image => image_to_show)
    end
    
    def parse_results(results)
      test_framework.parse_results(results)
    end

    def image_to_show
      if test_framework.failure?
        failure_image
      elsif test_framework.pending?
        pending_image
      else
        sucess_image
      end      
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
    
    def verbose?
      config.verbose
    end
    
    private
    
    def setting_test_framework
      case config.test_framework
      when :rspec
        Rspec.new :rubies => rubies
      when :test_unit
        TestUnit.new :rubies => rubies
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
      load_file :file => File.expand_path('~/.infinity_test')
    end
    
    def load_project_configuration
      load_file :file => './.infinity_test'
    end
    
    def load_file(options)
      file = options[:file]
      load(file) if File.exist?(file)
    end

  end
end