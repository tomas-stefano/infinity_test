module InfinityTest
  module Strategy
    class Base
      def initialize(continuous_test_server)
        @continuous_test_server = continuous_test_server
      end

      # ==== Returns
      # CommandBuilderClass: A class that builds that command using method_missing.
      #
      def command_builder
        Core::CommandBuilder.new
      end

      # Run the strategy and parse the results storing in the strategy.
      # Prints the command before executing if verbose mode is enabled.
      #
      def run
        command = run!
        puts "\n\e[96m[InfinityTest]\e[0m - Command: '\e[32m#{command}\e[0m'\n\n" if Core::Base.verbose?
        Core::CommandRunner.new(command)
      end

      # Check if bundler should be used.
      # Returns true if bundler is enabled and Gemfile exists.
      #
      def use_bundler?
        Core::Base.using_bundler? && File.exist?('Gemfile')
      end

      # Wrap command with bundle exec if bundler should be used.
      #
      def with_bundler(command)
        use_bundler? ? "bundle exec #{command}" : command
      end

      # Implement #run! method returning a string command to be run.
      #
      def run!
        raise NotImplementedError, "not implemented in #{self}"
      end

      # Put all the requires to autodiscover use your strategy instead of others.
      #
      def self.run?
        raise NotImplementedError, "not implemented in #{self}"
      end
    end
  end
end