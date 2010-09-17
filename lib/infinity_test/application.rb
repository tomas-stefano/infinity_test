module InfinityTest
  class Application
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
    
    def sucess_image
      config.sucess_image
    end
    
    def failure_image
      config.failure_image
    end
    
    def pending_image
      config.pending_image
    end
    
    def before_callback
      config.before_callback
    end
    
    def after_callback
      config.after_callback
    end
    
    def rubies
      config.rubies
    end
    
    def test_framework
      config.test_framework
    end
    
    def cucumber?
      config.use_cucumber?
    end
    
    def notification_framework
      config.notification_framework
    end

  end
end