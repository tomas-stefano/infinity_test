require 'watchr'

module InfinityTest
  module Observer
    class Watchr < Base
      def initialize
        @observer = ::Watchr::Script.new
      end

      def start
        ::Watchr::Controller.new(@observer, ::Watchr.handler.new).run
      end
    end
  end
end