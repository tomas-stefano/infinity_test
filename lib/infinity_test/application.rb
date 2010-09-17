module InfinityTest
  class Application
    attr_accessor :config, :library_directory_pattern
    
    def initialize
      @config = InfinityTest.configuration
      @library_directory_pattern = "^lib/*/(.*)\.rb"
    end
    
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