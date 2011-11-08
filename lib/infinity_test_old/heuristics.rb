module InfinityTest
  class Heuristics
    attr_reader :patterns, :script, :runner

    def initialize
      @patterns = {}
      @script = InfinityTest.watchr
      @application = InfinityTest.application
      @runner = InfinityTest.runner
    end

    # This example tell to InfinityTest do_something when ruby_file.rb is changed:
    #
    #  add('^my_dir/ruby_file.rb') { do_something }
    #
    def add(pattern, &block)
      @patterns[pattern] = block
      @script.watch(pattern, &block) # Watchr
      @patterns
    end

    # Remove pattern(s)
    #
    #  remove('my_pattern.rb') # => Remove my_pattern.rb from heuristics
    #  remove(:all) # => Remove all patterns
    #
    def remove(pattern)
      if pattern == :all
        @patterns.clear
        @script.rules.clear
      else
        @patterns.delete(pattern)
        @script.rules.delete_if { |rule| rule.pattern == pattern }
      end
    end

    # Return all the patterns for the application
    #
    def all
      @patterns.keys
    end

    # Run the files that match by the options patterns
    #
    # Example:
    #
    #  run(:all => :files) # => Run all test files
    #  run(:all => :files, :in_dir => :models) # => Run all the test files in the models directory
    #  run(:test_for => match_data)  # => Run the tests that match with the MatchData Object
    #  run(:test_for => match_data, :in_dir => :controllers) # => Run the tests that match with the MatchData Object
    #  run(match_data) # => Run the test file
    #
    def run(options)
      files = application_file.search(options)
      @runner.run_commands_for_changed_file(files)
    end
    
    private
      def application_file
        ApplicationFile.new(:test => @application.test_framework)
      end

  end
end
