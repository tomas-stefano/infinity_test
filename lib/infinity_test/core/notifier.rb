module InfinityTest
  module Core
    class Notifier
      include ::Notifiers

      attr_reader :test_framework, :library

      IMAGES = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'images'))

      delegate :test_message, to: :test_framework

      def initialize(options)
        @test_framework = options.fetch(:test_framework)
        @library        = options.fetch(:library)
      end

      def notify
        send(library).title(RUBY_VERSION).message(test_message).image(image).notify
      end

      def image
        return success_image if test_framework.success?

        if test_framework.failure?
          failure_image
        else
          pending_image
        end
      end

      def success_image
        find_image(:success)
      end

      def failure_image
        find_image(:failure)
      end

      def pending_image
        find_image(:pending)
      end

      def find_image(image_type)
        Dir.glob(File.join(images_dir, "#{image_type.to_s}*")).first
      end

      def images_dir
        mode = Core::Base.mode

        case mode
        when Symbol
          File.join(IMAGES, mode.to_s)
        when String
          File.expand_path(File.join(mode))
        end
      end
    end
  end
end