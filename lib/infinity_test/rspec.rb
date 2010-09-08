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
      @test_directory_pattern = "^spec/(.*)_spec.rb"
    end
    
    def construct_commands
      return construct_rubies_commands unless @rubies.empty?
      
      ruby_command = File.join(Config::CONFIG['bindir'], Config::CONFIG['ruby_install_name'])
      path = rspec_path
      if jruby?
        { JRUBY_VERSION => "#{ruby_command} #{path} spec --color" }
      else
        { RUBY_VERSION  => "#{ruby_command} #{path} spec --color" }
      end
    end
    
    def jruby?
      RUBY_PLATFORM == 'java'
    end
    
    def construct_rubies_commands(ruby=nil)
      results = Hash.new
      $stdout.puts "* Grabbing the Rspec Path for each Ruby (This may take some time for the first time)"
      RVM.environments(@rubies) do |environment|
        shell_result = environment.ruby(RSPEC_PATH_FILE).stdout
        ruby_version = environment.environment_name
        if shell_result =~ /Appears that you/
          puts "\n Ruby: #{ruby_version} => #{shell_result}"
        else
          results[ruby_version] = "rvm '#{ruby_version}' 'ruby' '#{shell_result} spec --color'"
        end
      end
      results
    end
    
  end
end