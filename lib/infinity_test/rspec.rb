module InfinityTest
  class Rspec    
    include InfinityTest::BinaryPath
    
    attr_reader :rubies, :test_directory_pattern
    
    RSPEC_PATH_FILE = File.expand_path(File.join(File.dirname(__FILE__), 'binary_path', 'rspec.rb'))
    
    # rspec = InfinityTest::Rspec.new(:rubies => '1.9.1,1.9.2')
    # rspec.rubies # => '1.9.1,1.9.2'
    # rspec.run!
    #
    def initialize(options={})
      @rubies = options[:rubies] || []
      @test_directory_pattern = "^spec/*/(.*)_spec.rb"
    end
    
    def construct_commands
      return construct_rubies_commands unless @rubies.empty?
      
      ruby_command = File.join(Config::CONFIG['bindir'], Config::CONFIG['ruby_install_name'])
      path = rspec_path
      command = "#{ruby_command} #{path} #{spec_files}"
      if jruby?
        { JRUBY_VERSION => command }
      else                                                       
        { RUBY_VERSION  => command }
      end
    end
    
    def jruby?
      RUBY_PLATFORM == 'java'
    end
    
    def spec_files
      Dir['spec/**/*_spec.rb'].collect { |file| file }.join(' ')
    end
    
    def construct_rubies_commands(ruby=nil)
      results = Hash.new
      puts 'Search the Paths (This take some time ONLY in the FIRST TIME)'
      RVM.environments(@rubies) do |environment|
        shell_result = environment.ruby(RSPEC_PATH_FILE).stdout
        ruby_version = environment.environment_name
        puts "Search the Rspec Bin Path for #{ruby_version}"
        if error_in_the_shell? shell_result
          puts "\n Ruby => #{ruby_version}: #{shell_result}"
        else
          results[ruby_version] = "rvm '#{ruby_version}' 'ruby' '#{shell_result} #{spec_files}'"
        end
      end
      results
    end
    
    def error_in_the_shell?(shell_result)
      shell_result =~ /Appears that you/
    end
    
  end
end