module InfinityTest
  class TestUnit
    attr_reader :rubies
    
    def initialize(options={})
      @rubies = options[:rubies]
    end
    
    def test_directory_pattern
      "^test/(.*)_test.rb"
    end
    
    def construct_commands
      
    end
    
    #  def build_command_string(ruby_versions)
    #    files = collect_test_files.unshift(test_loader).join(' ')
    #    ruby_string = "ruby -Ilib:test #{files}"
    #    unless files.empty? and ruby_versions        
    #      if ruby_versions.empty?
    #        ruby_string
    #      else
    #        "rvm #{ruby_versions} #{ruby_string}"
    #      end
    #    end
    #  end
    
    # def commands_for_test_unit
    #   { RUBY_VERSION => InfinityTest::TestUnit.new.build_command_string(@rubies) }
    # end
    
    def collect_test_files
      Dir['test/**/*_test.rb'].collect { |file| file }
    end

    def test_loader
      $LOAD_PATH.each do |path|
        file_path = File.join(path, "infinity_test/test_unit_loader.rb")    
        return file_path if File.exist?(file_path)
      end
    end
  
  end
end