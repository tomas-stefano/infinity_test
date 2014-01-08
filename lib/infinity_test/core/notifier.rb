module InfinityTest
  module Core
    class Notifier
      include ::Notifiers

      def initialize(options)
        @notify_library = options.fetch(:notify_library)
        @message        = options.fetch(:message)
      end

      def notify
        send(@notify_library).message(@message)
      end
    end
  end
end