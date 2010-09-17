module InfinityTest
  class Rspec
    attr_accessor :rubies, :test_directory_pattern, :message, :test_pattern, :failure, :sucess, :pending
    
    #
    # rspec = InfinityTest::Rspec.new(:rubies => '1.9.1,1.9.2')
    # rspec.rubies # => '1.9.1,1.9.2'
    #
    def initialize(options={})
      @rubies = options[:rubies] || []
      @test_directory_pattern = "^spec/*/(.*)_spec.rb"
      @test_pattern = options[:test_pattern] || 'spec/**/*_spec.rb'
    end
    
    def construct_commands
      @rubies << RVM::Environment.current.environment_name if @rubies.empty?
      construct_rubies_commands
    end
    
    def spec_files
      Dir[@test_pattern].collect { |file| file }.join(' ')
    end
    
    def construct_rubies_commands
      results = Hash.new
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
        @example, @pending, @failure = 0, 0, 1
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
      @pending > 0 and not failure?
    end
    
  end
end