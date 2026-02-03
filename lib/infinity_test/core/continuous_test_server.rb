module InfinityTest
  module Core
    class ContinuousTestServer
      attr_reader :base
      delegate :binary, :test_files, to: :test_framework
      delegate :infinity_and_beyond, :notifications, :extension, :just_watch, :focus, to: :base

      def initialize(base)
        @base = base
      end

      def start
        print_banner
        run_strategy unless just_watch
        start_observer
      end

      # Print startup banner showing detected configuration.
      #
      def print_banner
        puts "\e[96m"
        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        puts "  InfinityTest - To Infinity and Beyond!"
        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        puts "  Framework:      #{base.framework}"
        puts "  Test Framework: #{base.test_framework}"
        puts "  Strategy:       #{base.strategy}"
        puts "  Bundler:        #{Base.using_bundler? && File.exist?('Gemfile') ? 'yes' : 'no'}"
        puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
        puts
      end

      # Run strategy based on the choosed ruby strategy.
      #
      def run_strategy
        Base.run_before_callbacks(:all)

        apply_focus if focus.present?
        notify(strategy.run)

        Base.run_after_callbacks(:all)
      ensure
        clear_focus
      end

      # Apply focus filter to test files
      #
      def apply_focus
        case focus
        when :failures
          test_framework.test_files = last_failed_files if last_failed_files.present?
        when String
          test_framework.test_files = focus if File.exist?(focus)
        end
      end

      # Clear focus after running tests
      #
      def clear_focus
        test_framework.test_files = nil
      end

      # Track last failed test files (stored in .infinity_test_failures)
      #
      def last_failed_files
        failures_file = '.infinity_test_failures'
        return nil unless File.exist?(failures_file)
        File.read(failures_file).split("\n").select { |f| File.exist?(f) }.join(' ')
      end

      # Re run strategy changed the changed files.
      #
      def rerun_strategy(files)
        test_framework.test_files = files
        run_strategy
      ensure
        test_framework.test_files = nil
      end

      def notify(strategy_result)
        if notifications.present?
          test_framework.test_message = strategy_result

          Core::Notifier.new(library: notifications, test_framework: test_framework).notify
        end
      end

      # Start to monitoring files in the project.
      #
      def start_observer
        if infinity_and_beyond.present?
          framework.heuristics!
          observer.start!
        end
      end

      # Returns the instance for the configured strategy.
      #
      def strategy
        @strategy ||= "InfinityTest::Strategy::#{base.strategy.to_s.classify}".constantize.new(self)
      end

      # Return a cached test framework instance.
      #
      def test_framework
        @test_framework ||= "::InfinityTest::TestFramework::#{base.test_framework.to_s.classify}".constantize.new
      end

      # Return a framework instance based on the base framework accessor.
      #
      def framework
        @framework ||= "::InfinityTest::Framework::#{base.framework.to_s.camelize}".constantize.new(self)
      end

      # Return a cached observer instance by the observer accessor.
      #
      def observer
        @observer ||= "::InfinityTest::Observer::#{base.observer.to_s.classify}".constantize.new(self)
      end
    end
  end
end