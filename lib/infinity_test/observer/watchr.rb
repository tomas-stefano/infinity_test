require 'watchr'

module InfinityTest
  module Observer
    class Watchr < Base
      def initialize(continuous_test_server)
        super
        @observer = ::Watchr::Script.new
      end

      # ==== Examples
      #
      #   watch('lib/(.*)\.rb') { |match_data| system("ruby test/test_#{match_data[1]}.rb") }
      #   watch('test/test_helper.rb') { RunAll() }
      #
      def watch(pattern_or_file, &block)
        @observer.watch(pattern_or_file.to_s) do |match_data|
          block.call(InfinityTest::Core::ChangedFile.new(match_data))
        end
      end

      # ==== Examples
      #
      #   watch_dir(:lib) { |file| RunTest(file) }
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