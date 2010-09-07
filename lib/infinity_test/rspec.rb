module InfinityTest
  class Rspec
    attr_reader :rubies
    
    # rspec = InfinityTest::Rspec.new(:rubies => '1.9.1,1.9.2')
    # rspec.rubies # => '1.9.1,1.9.2'
    # rspec.run!
    #
    def initialize(options={})
      @rubies = options[:rubies]
    end
    
    def test_directory_pattern
      "^spec/(.*)_spec.rb"
    end
    
    def construct_commands
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
    
    def rspec_path
      begin
        Gem.bin_path('rspec', 'spec') # Rspec 1.3.0
      rescue Exception
        Gem.bin_path('rspec-core', 'rspec') # Rspec 2.0.0.beta
      rescue Exception
        $stdout.puts("Appears that you don't have Rspec (1.3.0 or 2.0.beta) installed. Run with: \n gem install rspec  or gem install rspec --pre")
      end
    end

    #    file = File.join(File.dirname(__FILE__), 'binary_path', 'rspec')
    #    RVM.environments('1.8.7-p249,1.9.2') do |environment|
    #      @result.push(environment.ruby(file))
    #    end
    #    @commands = @result.collect { |result| result.stdout }    
    #
    #def some
    #  file = File.expand_path(File.join(File.dirname(__FILE__), 'binary_path', 'rspec.rb'))
    #  results = {}
    #  unless @rubies.empty?
    #    puts "* Grabbing the Rspec Path for each Ruby"
    #    RVM.environments(@application.rubies) do |environment|
    #      results[environment.environment_name] = environment.ruby(file).stdout + ' spec --color'
    #    end
    #    results
    #  else
    #    rspec = { RUBY_VERSION => "#{Gem.bin_path('rspec-core', 'rspec') + ' spec'}" }
    #  end
    #end
    
  end
end