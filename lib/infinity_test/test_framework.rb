module InfinityTest
  class TestFramework
    include BinaryPath

    binary :bundle

    attr_accessor :application, :message, :test_directory_pattern, :rubies, :test_pattern
    
    def initialize(options={})
      @application = InfinityTest.application
      @rubies = options[:rubies] || []
    end
    
    # Run in context of each Ruby Environment, and the Ruby Version
    #
    # This is NOT RESPONSABILITY of TEST FRAMEWORKS!!!
    #
    def environments(&block)
      raise unless block_given?
      RVM.environments(rubies).each do |environment|
        ruby_version = environment.environment_name
        block.call(environment, ruby_version)
      end
    end
    
    # This is NOT RESPONSABILITY of TEST FRAMEWORKS!!!
    #
    def construct_command(options)
      binary_name, ruby_version, command, file, environment = resolve_options(options)
      unless have_binary?(binary_name) || options[:skip_binary?]
        print_message(binary_name, ruby_version)
      else
        command = "#{command} #{decide_files(file)}"
        rvm_ruby_version = "rvm #{ruby_version} ruby"
        if application.have_gemfile? and not application.skip_bundler?
          run_with_bundler!(rvm_ruby_version, command, environment)
        else
          run_without_bundler!(rvm_ruby_version, command)
        end
      end
    end

    # This is NOT RESPONSABILITY of TEST FRAMEWORKS!!!
    #    
    def run_with_bundler!(rvm_ruby_version, command, environment)
      bundle_binary = search_bundle(environment)
      unless have_binary?(bundle_binary)
        print_message('bundle', environment.expanded_name)
      else
        %{#{rvm_ruby_version} #{bundle_binary} exec #{command}}
      end
    end
    
    # This is NOT RESPONSABILITY of TEST FRAMEWORKS!!!
    #
    def run_without_bundler!(rvm_ruby_version, command)
      %{#{rvm_ruby_version} #{command}}
    end
    
    # THIS IS NOT RESPONSABILITY OF TEST FRAMEWORKS!!
    #
    # Contruct all the Commands for each ruby instance variable
    # If don't want to run with many rubies, add the current ruby to the rubies instance
    # and create the command with current ruby
    #
    def construct_commands(file=nil)
      @rubies << RVM::Environment.current.environment_name if @rubies.empty?
      construct_rubies_commands(file)
    end
    
    # Return all the files match by test_pattern
    #
    def all_files
      Dir[@test_pattern]
    end
    
    def test_files
      all_files.collect { |file| file }.join(' ')
    end
    
    def decide_files(file)
      return file if file
      test_files
    end
    
    # Method used in the subclasses of TestFramework
    #
    # Example:
    #
    #  class Rspec < TestFramework
    #    parse_results :example => /(\d+) example/, :failure => /(\d+) failure/, :pending => /(\d+) pending/
    #  end
    #
    # Then will create @examples, @failure and @pending instance variables with the values in the test result
    #
    # Or with Test::Unit:
    #
    #  class TestUnit < TestFramework
    #    parse_results :tests => /(\d+) tests/, :assertions => /(\d+) assertions/, :failures => /(\d+) failures/, :errors => /(\d+) errors/
    #  end
    #
    # Then will create @tests, @assertions, @failures and @errors instance variables with the values in the test result
    #
    def self.parse_results(patterns)
      raise(ArgumentError, 'patterns should not be empty') if patterns.empty?
      create_accessors(patterns)
      define_method(:parse_results) do |results|
        create_instances(:shell_result => test_message(results, patterns), :patterns => patterns)
      end
    end
    
    # Create accessors for keys of the Hash passed in argument
    #
    # create_accessors({ :example => '...', :failure => '...'}) # => attr_accessor :example, :failure
    #
    def self.create_accessors(hash)
      hash.keys.each do |attribute|
        attr_accessor attribute
      end
    end
    
    # Create the instance pass in the patterns options
    #
    # Useful for the parse results:
    #  parse_results :tests => /.../, :assertions => /.../
    #
    # Then will create @tests ans @assertions (the keys of the Hash)
    #
    def create_pattern_instance_variables(patterns, shell_result)
      patterns.each do |key, pattern|
        number = shell_result[pattern, 1].to_i
        instance_variable_set("@#{key}", number)
      end      
      @message = shell_result.gsub(/\e\[\d+?m/, '') # Clean ANSIColor strings
    end
    
    # Return the message of the tests
    #
    # test_message('0 examples, 0 failures', { :example => /(\d) example/}) # => '0 examples, 0 failures'
    # test_message('....\n4 examples, 0 failures', { :examples => /(\d) examples/}) # => '4 examples, 0 failures'
    #
    def test_message(output, patterns)
      lines = output.split("\n")
      final_result = []
      patterns.each do |key, pattern|
        final_result << lines.select { |line| line =~ pattern }
      end
      final_result.flatten.first
    end
    
    private
    
      def create_instances(options)
        shell_result, patterns = options[:shell_result], options[:patterns]
        if shell_result
          create_pattern_instance_variables(patterns, shell_result)
        else
          patterns.each { |instance, pattern| instance_variable_set("@#{instance}", 1) } # set all to 1 to show that an error occurred
          @message = "An exception occurred"
        end      
      end
    
      def resolve_options(options)
        ruby_version = options[:for]
        binary_name = options[:skip_binary?] ? '' : options[:binary]
        load_path = %{-I"#{options[:load_path]}"} if options[:load_path]
        environment = options[:environment]
        file = options[:file]
        command = [ binary_name, load_path].compact.join(' ')
        [binary_name, ruby_version, command, file, environment]
      end
    
  end
end