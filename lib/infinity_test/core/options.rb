module InfinityTest
  module Core
    class Options
      attr_accessor :arguments, :options_parser, :strategy, :bundler, :verbose
      attr_accessor :rubies, :specific_options, :test_framework, :framework

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
        option.on('--ruby strategy', 'Ruby Manager. Ex.: rvm, rbenv, default') do |strategy|
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
        option.on('--test library', 'Test Framework to be run. Ex.: rspec, test_unit, bacon.') do |library|
          @test_framework = library.to_sym
        end
      end

      def app_framework(option)
        option.on('--framework library', 'Application Framework to be run and added the patterns to search changed files. Ex.: rails, rubygems.') do |library|
          @framework = library.to_sym
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