require 'watchr'

module InfinityTest
  module Observer
    class Watchr < Base
      def initialize
        @observer = ::Watchr::Script.new
      end

      def watch(pattern_or_file, &block)
        @observer.watch(pattern_or_file.to_s, &block)
      end

      def watch_dir(dir_name, extension = :rb, &block)
        @observer.watch("^#{dir_name}/*/(.*).#{extension}", &block)
      end

      def start
        @handler = ::Watchr.handler.new
        @controller = ::Watchr::Controller.new(@observer, @handler)
        @controller.run
      end
    end
  end
end