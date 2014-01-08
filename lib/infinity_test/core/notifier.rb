module InfinityTest
  module Core
    class Notifier
      include ::Notifiers

      def initialize(options)
        @notify_library = options.fetch(:notify_library)
        @message        = options.fetch(:message)
        @image          = options.fetch(:image)
      end

      def notify
        send(@notify_library).message(@message).image(@image)
      end
    end
  end
end