module InfinityTest
  module TestLibrary
    class Bacon < TestFramework
      include BinaryPath
      
      binary :bacon
      parse_results :specifications => /(\d+) specifications/, :requirements => /(\d+) requirements/, :failures => /(\d+) failure/, :errors => /(\d+) errors/
      
      #
      # construct_commands(:bacon) do |environment, ruby_version|
      #
      #   command = "rvm #{ruby_version} ruby"
      #   bacon_binary = search_bacon(environment)
      #   unless have_binary?(bacon_binary)
      #     print_message('bacon', ruby_version)
      #   else
      #     results[ruby_version] = "rvm #{ruby_version} ruby #{bacon_binary} #{decide_files(file)}"
      #   end
      # end
      #
      # bacon = InfinityTest::Bacon.new(:rubies => '1.9.1,1.9.2')
      # bacon.rubies # => '1.9.1,1.9.2'
      #
      def initialize(options={})
        super(options)
        @test_directory_pattern = "^spec/*/(.*)_spec.rb"
        @test_pattern = options[:test_pattern] || 'spec/**/*_spec.rb'
      end
      
      #  environments do |environment, ruby_version|
      #    bacon_binary = search_bacon(environment)
      #    create_command(:ruby_version => ruby_version, :binary => bacon_binary)
      #  end
      #
      #  def create_command(options)
      #    ruby_version = options[:ruby_version]   
      #    binary_name = options[:binary]
      #    if have_gemfile?
      #      run_with_bundler!
      #    else
      #      run_without_bundler!
      #    end
      #  end
      #
      #  def have_gemfile?
      #    gemfile = File.join(File.dirname(__FILE__), 'Gemfile')
      #    File.exist?(gemfile)
      #  end
      #
      
      def construct_rubies_commands(file=nil)
        results = Hash.new
        RVM.environments(@rubies) do |environment|
          ruby_version = environment.environment_name
          bacon_binary = search_bacon(environment)
          unless have_binary?(bacon_binary)
            print_message('bacon', ruby_version)
          else
            results[ruby_version] = "rvm #{ruby_version} ruby #{bacon_binary} -Ilib -d #{decide_files(file)}"
          end
        end
        results
      end
            
      def sucess?
        return false if failure?
        true
      end
      
      def failure?
        @failures > 0
      end
      
    end    
  end
end
