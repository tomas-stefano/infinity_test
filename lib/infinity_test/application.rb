module InfinityTest
  class Application
    attr_accessor :config
    
    def initialize
      @config = InfinityTest.configuration
    end
    
    def library_directory_pattern
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
    
    def rubies
      config.rubies
    end
    
    def test_framework
      config.test_framework
    end
    
    def cucumber?
      config.use_cucumber?
    end
    
  end
end