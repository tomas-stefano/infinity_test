module InfinityTest
  class TestUnit
    attr_reader :rubies, :message, :test_directory_pattern
    
    def initialize(options={})
      @rubies = options[:rubies] || []
      @test_directory_pattern = "^test/*/(.*)_test.rb"
    end
    
    def construct_commands
      return construct_rubies_commands unless @rubies.empty?
      ruby_version = RUBY_PLATFORM == 'java' ? JRUBY_VERSION : RUBY_VERSION
      ruby_command = File.join(Config::CONFIG['bindir'], Config::CONFIG['ruby_install_name'])
      unless test_files.empty? or test_files.size == 1
        { ruby_version => "#{ruby_command} -I'lib:test' #{test_files}"}
      end
    end
    
    def construct_rubies_commands
      results = Hash.new
      RVM.environments(@rubies) do |environment|
        ruby_version = environment.environment_name
        results[ruby_version] = "rvm #{ruby_version} ruby -I'lib:test' #{test_files}"
      end
      results
    end
    
    def test_files
      collect_test_files.unshift(test_loader).join(' ')
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
    
    def parse_results(results)
      shell_result = results.split("\n")
      shell_result = shell_result.select { |line| line =~ /(\d+) tests/}.first
      if shell_result
        @message = shell_result
      else
        @message = "An exception ocurred"
      end
    end
  
  end
end