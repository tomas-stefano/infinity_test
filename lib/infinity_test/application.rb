module InfinityTest
  class Application
    attr_accessor :config
    
    def initialize
      @config = InfinityTest.configuration
    end
    
    def load_configuration_file
      [File.expand_path('~/.infinity_test')].each do |file|
        load file if File.exist?(file)
      end
    end
    
    def rvm_versions
      config.rvm_versions
    end
    
    def test_framework
      config.test_framework
    end
    
    def cucumber?
      config.use_cucumber?
    end
    
    def gem_not_found_message(gem_name)
      say "\n Appears that you don't have #{gem_name.capitalize} installed. Run with: \n gem install #{gem_name} \n "
      raise
    end

    def say(something)
      $stdout.puts(something)
    end
    
  end
end