module InfinityTest
  module Observer
    class Base
      attr_accessor :observer

      def watch(pattern_or_file, &block)
        raise NotImplementedError, "not implemented in #{self}"
      end

      def watch_dir(dir_name, extension, &block)
        raise NotImplementedError, "not implemented in #{self}"
      end

      def start
        raise NotImplementedError, "not implemented in #{self}"
      end

      def signal
        Signal.trap('INT') do
          if @interrupt
            puts " To Infinity and Beyond!"
            exit
          else
            puts " Are you sure? :S ... Interrupt a second time to quit!"
            @interrupt = true
            Kernel.sleep 1.5
            Core::Base.run_strategy!
            @interrupt = false
          end
        end
      end
    end
  end
end