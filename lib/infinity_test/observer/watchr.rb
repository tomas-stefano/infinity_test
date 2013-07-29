require 'watchr'

module InfinityTest
  module Observer
    class Watchr < Base
      attr_reader :observer

      def initialize(continuous_test_server)
        super
        @observer = ::Watchr::Script.new
      end

      # ==== Examples
      #
      #   watch('lib/(.*)\.rb') { |file| puts [file.name, file.path, file.match_data] }
      #   watch('test/test_helper.rb') { RunAll() }
      #
      def watch(pattern_or_file, &block)
        @observer.watch(pattern_or_file.to_s) do |match_data|
          block.call(InfinityTest::Core::ChangedFile.new(match_data))
        end
      end

      # ==== Examples
      #
      #   watch_dir(:lib)  { |file| RunTest(file) }
      #   watch_dir(:test) { |file| RunFile(file) }
      #
      #   watch_dir(:test, :py) { |file| puts [file.name, file.path, file.match_data] }
      #   watch_dir(:test, :js) { |file| puts [file.name, file.path, file.match_data] }
      #
      def watch_dir(dir_name, extension = :rb, &block)
        watch("^#{dir_name}/*/(.*).#{extension}", &block)
      end

      # Start the continuous test server.
      #
      def start
        @handler    = ::Watchr.handler.new
        @controller = ::Watchr::Controller.new(@observer, @handler)
        @controller.run
      end
    end
  end
end