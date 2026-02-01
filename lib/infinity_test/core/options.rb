module InfinityTest
  module Core
    class Options
      attr_accessor :arguments, :options_parser, :strategy, :bundler, :verbose
      attr_accessor :rubies, :specific_options, :test_framework, :framework, :infinity_and_beyond
      attr_accessor :notifications, :mode, :just_watch, :focus

      def initialize(*arguments)
        @arguments = arguments.flatten.clone
        @options_parser = new_options_parser
      end

      def new_options_parser
        OptionParser.new do |option|
          %w(
            ruby_strategy
            ruby_versions
            options_to_added_in_the_command
            test_framework_to_be_run
            app_framework
            notifications_library
            image_mode
            infinity_and_beyond_option
            just_watch_option
            focus_option
            verbose_mode
            skip_bundler
          ).each do |option_to_parse|
            send(option_to_parse, option)
          end
          banner(option)
          help(option)
        end
      end

      def parse!
        @options_parser.parse!(@arguments)

        self
      end

      def ruby_strategy(option)
        option.on('--ruby strategy', 'Ruby Manager. Ex.: auto_discover, rvm, rbenv, ruby_default') do |strategy|
          @strategy = strategy.to_sym
        end
      end

      def ruby_versions(option)
        option.on('--rubies=rubies', 'Specify Ruby version(s) to test against') do |versions|
          @rubies = versions.split(',')
        end
      end

      def options_to_added_in_the_command(option)
        option.on('--options=options', 'Pass the options to be added. Ex. -Ilib-Itest-Iapp') do |options|
          @specific_options = options.split('-').join(' -').strip
        end
      end

      def test_framework_to_be_run(option)
        option.on('--test library', 'Test Framework to be run. Ex.: auto_discover, rspec, test_unit.') do |library|
          @test_framework = library.to_sym
        end
      end

      def app_framework(option)
        option.on('--framework library', 'Application Framework to be run and added the patterns to search changed files. Ex.: auto_discover, rails, rubygems, padrino.') do |library|
          @framework = library.to_sym
        end
      end

      def notifications_library(option)
        option.on('--notifications library', 'Notification library to use. Ex.: auto_discover, osascript, terminal_notifier, notify_send, dunstify.') do |library|
          @notifications = library.to_sym
        end
      end

      def image_mode(option)
        option.on('--mode theme', 'Image theme for notifications. Ex.: simpson, faces, fuuu, hands, mario_bros, rails, rubies, street_fighter, toy_story.') do |theme|
          @mode = theme.to_sym
        end
      end

      def infinity_and_beyond_option(option)
        option.on('-n', '--no-infinity-and-beyond', 'Run tests and exit. Useful in a Continuous Integration environment.') do
          @infinity_and_beyond = false
        end
      end

      def just_watch_option(option)
        option.on('-j', '--just-watch', 'Skip initial test run and only watch for file changes. Useful for large applications.') do
          @just_watch = true
        end
      end

      def focus_option(option)
        option.on('-f', '--focus [FILE]', 'Focus on specific tests. Use "failures" for failed tests, or provide a file path.') do |file|
          @focus = file == 'failures' ? :failures : file
        end
      end

      def verbose_mode(option)
        option.on('--no-verbose', "Don't print commands before executing them") do
          @verbose = false
        end
      end

      def skip_bundler(option)
        option.on('--no-bundler', "Bypass Infinity Test's Bundler support") do
          @bundler = false
        end
      end

      def banner(option)
        option.banner = [ "Usage: infinity_test [options]", "Run tests"].join("\n")
      end

      def help(option)
        option.on_tail("--help", "You're looking at it.") do
          print option.help
          exit
        end
      end

      def verbose?
        @verbose
      end

      def bundler?
        @bundler
      end
    end
  end
end