module InfinityTest
  class Notification
    attr_accessor :notifier, :action, :sucess_image, :failure_image, :pending_image
    attr_reader :default_dir_images
    
    IMAGES_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'images'))
    
    SUCESS  = 'sucess'
    FAILURE = 'failure'
    PENDING = 'pending'
    
    # Class responsible to settings the images and show notifications to the user
    #
    def initialize(notification_app=nil, &block)
      @notifier = notification_app
      @action = block
      @default_dir_images = File.join(IMAGES_DIR, 'simpson')
      search_all_images_and_set_the_instances!
      self.instance_eval(&block) if block_given?
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
    def show_images(options)
      change_dir_images(options[:mode]) if options[:mode]
      search_all_images_and_set_the_instances!(options)
    end
    
    # Change dir images(if you don't like the DSL use this method)
    #
    # Example:
    #
    #  change_dir_images :simpson # => This will show images in the folder http://github.com/tomas-stefano/infinity_test/tree/master/images/simpson
    #  change_dir_images :street_fighter # => This will show images in folder http://github.com/tomas-stefano/infinity_test/tree/master/images/street_fighter
    #  change_dir_images '~/My/Mode' # => This will show images in the '~/My/Mode' directory
    #
    def change_dir_images(folder)
      case folder
      when Symbol
        @default_dir_images = File.join(IMAGES_DIR, folder.to_s)
      when String
        @default_dir_images = File.expand_path(File.join(folder))
      end
    end

    # Search the sucess, failure or pending images in the default dir images
    # and return the first in the pattern
    #
    def search_image(file)
      Dir.glob(File.join(@default_dir_images, file) + '*').first
    end
    
    private
    
      def search_all_images_and_set_the_instances!(options={})
        @sucess_image  = options[:sucess]  || search_image(SUCESS)
        @pending_image = options[:pending] || search_image(PENDING)
        @failure_image = options[:failure] || search_image(FAILURE)        
      end

  end
end