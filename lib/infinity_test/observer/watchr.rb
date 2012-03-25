require 'watchr'

module InfinityTest
  module Observer
    class Watchr < Base
      def initialize
        @observer = ::Watchr::Script.new
      end

      def start
        @handler = ::Watchr.handler.new
        @controller = ::Watchr::Controller.new(@observer, @handler)
        @controller.run
      end

      def signal
        # Signal.trap('INT') do
        #   if @interrupt
        #     puts " Shutting down now. Have a nice day!"
        #     exit
        #   else
        #     puts " Interrupt a second time to quit!"
        #     @sent_an_int = true
        #     Kernel.sleep 1.1
        #     @application.run_global_commands!
        #     @sent_an_int = false
        #   end
        # end
      end
    end
  end
end