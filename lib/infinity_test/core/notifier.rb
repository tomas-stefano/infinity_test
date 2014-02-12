module InfinityTest
  module Core
    class Notifier
      include ::Notifiers

      attr_reader :test_framework, :library

      IMAGES = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'images'))

      def initialize(options)
        @test_framework = options.fetch(:test_framework)
        @library        = options.fetch(:library)
      end

      def notify
        send(library).message(test_message).image(image).notify
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
        File.join(IMAGES, Core::Base.mode.to_s)
      end

      # Set the Success and Failure image to show in the notification framework
      #
      #   show_images :failure => 'Users/tomas/images/my_custom_image.png', :sucess => 'custom_image.jpg'
      #
      # Or you cant set modes(directory) for show images (please see the images folder in => http://github.com/tomas-stefano/infinity_test/tree/master/images/ )
      #
      #  show_images :mode => :simpson # => This will show images in the folder http://github.com/tomas-stefano/infinity_test/tree/master/images/simpson
      #  show_images :mode => :street_fighter # => This will show images in folder http://github.com/tomas-stefano/infinity_test/tree/master/images/street_fighter
      #  show_images :mode => '~/My/Mode' # => This will show images in the '~/My/Mode' directory
      #
      # The Convention in images folder is to set sucess, failure and pending images, and
      # Infinity test will work on these names in the notification framework
      #
      # def show_images(options={})
      #         switch_mode!(options[:mode]) if options[:mode]
      #         @sucess_image  = options[:sucess]  || search_image(SUCESS)
      #         @failure_image = options[:failure] || search_image(FAILURE)
      #         @pending_image = options[:pending] || search_image(PENDING)
      #       end
      #
      #       # Switch the image directory to show
      #       #
      #       def switch_mode!(mode)
      #         case mode
      #         when Symbol
      #           @default_dir_image = File.join(IMAGES_DIR, mode.to_s)
      #         when String
      #           @default_dir_image = File.expand_path(File.join(mode))
      #         end
      #       end
      #
      #       # Search the sucess, failure or pending images and return the first in the pattern
      #       #
      #       def search_image(file)
      #         Dir.glob(File.join(@default_dir_image, file) + '*').first
      #       end
      #
    end
  end
end