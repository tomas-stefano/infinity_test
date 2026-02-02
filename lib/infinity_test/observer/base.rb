module InfinityTest
  module Observer
    class Base
      attr_accessor :continuous_test_server

      def initialize(continuous_test_server)
        @continuous_test_server = continuous_test_server
      end

      def watch(pattern_or_file, &block)
        raise NotImplementedError, "not implemented in #{self}"
      end

      def watch_dir(dir_name, extension, &block)
        raise NotImplementedError, "not implemented in #{self}"
      end

      def start!
        signal
        start
      end

      def start
        raise NotImplementedError, "not implemented in #{self}"
      end

      def signal
        Signal.trap('INT') do
          if @interrupt_at && (Time.now - @interrupt_at) < 2
            puts " To Infinity and Beyond!"
            exit
          else
            puts " Are you sure? :S ... Interrupt a second time to quit!"
            @interrupt_at = Time.now
          end
        end
      end
    end
  end
end
