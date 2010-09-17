module InfinityTest
  class Rspec
    include InfinityTest::BinaryPath
    
    attr_reader :rubies, :test_directory_pattern, :message
    
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
        ruby_version = environment.environment_name
        rspec_binary = search_rspec_two(environment)
        rspec_binary = search_rspec_one(environment) unless File.exist?(rspec_binary)
        unless File.exist?(rspec_binary)
          puts "\n Ruby => #{ruby_version}:  I searched the rspec bin path and I don't find nothing. You have the rspec installed in this version?"
        else
          results[ruby_version] = "rvm #{ruby_version} ruby #{rspec_binary} #{spec_files}"
        end
      end
      results
    end
    
    def search_rspec_two(environment)
      File.expand_path(rvm_bin_path(environment, 'rspec'))
    end
    
    def search_rspec_one(environment)
      File.expand_path(rvm_bin_path(environment, 'spec'))
    end
    
    def rvm_bin_path(environment, rspec_bin)
      "~/.rvm/gems/#{environment.expanded_name}/bin/#{rspec_bin}"
    end
    
    def parse_results(results)
      shell_result = results.split("\n").last
      if shell_result =~ /example/
        @example = shell_result[/(\d+) example/, 1].to_i
        @failure = shell_result[/(\d+) failure/, 1].to_i
        @pending = shell_result[/(\d+) pending/, 1].to_i
        @message = "#{@example} examples, #{@failure} failures, #{@pending} pending"
      else
        @message = "An exception occurred"
      end
    end
    
    def sucess?
      return false if failure? or pending?
      true
    end
    
    def failure?
      @failure > 0
    end
    
    def pending?
      @pending > 0
    end
    
  end
end