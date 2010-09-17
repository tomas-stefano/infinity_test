module InfinityTest
  class Configuration
    
    SUPPORTED_FRAMEWORKS = [:growl, :lib_notify] # :snarl, :lib_notify
    
    attr_accessor :notification_framework, :sucess_image, :failure_image, :pending_image, :rubies, :cucumber, :test_framework, 
                  :exceptions_to_ignore, :before_callback, :after_callback
    
    IMAGES_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'images'))
    
    # Initialize the Configuration object that keeps the images, callbacks
    # and rubies, cucumber and the test framework
    # 
    def initialize
      @default_dir_image = File.join(IMAGES_DIR, 'simpson')
      @sucess_image  = 'sucess'
      @failure_image = 'failure'
      @pending_image = 'pending'
      @test_framework = :test_unit
    end
    
    # Set the notification framework to use with Infinity Test.
    # The supported Notification Frameworks are:
    #
    # * Growl
    # * Lib-Notify
    #
    # Here is the example of little Domain Specific Language to use:
    #
    # notifications :growl do
    #   # block
    # end
    #
    def notifications(framework, &block)
      raise NotificationFrameworkDontSupported, "Notification :#{framework} don't supported. The Frameworks supported are: #{SUPPORTED_FRAMEWORKS.join(',')}" unless SUPPORTED_FRAMEWORKS.include?(framework)
      @notification_framework = framework
      yield self if block_given?
      self
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
    def show_images(options={})
      switch_mode!(options[:mode]) if options[:mode]
      @sucess_image = setting_image(options[:sucess])   || search_image(@sucess_image)
      @failure_image = setting_image(options[:failure]) || search_image(@failure_image)
      @pending_image = setting_image(options[:pending]) || search_image(@pending_image)
    end
    
    # Switch the image directory to show
    #
    def switch_mode!(mode)
      case mode
      when Symbol
        @default_dir_image = File.join(IMAGES_DIR, mode.to_s)
      when String
        @default_dir_image = File.expand_path(File.join(mode))
      end
    end
    
    def setting_image(image)
      image unless image.equal?(:default)
    end
    
    # Search the sucess, failure or pending images and return the first in the pattern
    #
    def search_image(file)
      Dir.glob(File.join(@default_dir_image, file) + '*').first
    end
    
    # The options method to set:
    # * test framework 
    # * ruby versions
    # * use cucumber or not
    # 
    # Here is the example of Little Domain Language:
    #
    # use :rubies => ['1.9.1', '1.9.2'], :test_framework => :rspec, :cucumber => true
    #
    # use :rubies => [ '1.8.7-p249', '1.9.2@rails3'], :test_framework => :test_unit
    #
    def use(options={})
      rubies = options[:rubies]
      @rubies = (rubies.is_a?(Array) ? rubies.join(',') : rubies) || []
      @cucumber = options[:cucumber] || false
      @test_framework = options[:test_framework] || @test_framework
    end
    
    # Method to use to ignore some dir/files changes
    # 
    # Example:
    #
    # ignore :exceptions => %w(.svn .hg .git vendor tmp config rerun.txt)
    #
    # This is useless right now in the Infinity Test because the library 
    # only monitoring lib and test/spec folder.
    #
    def ignore(options={})
      @exceptions_to_ignore = options[:exceptions] || []
    end
    
    # Callback method to run anything you want, before the run the test suite command
    # 
    # Example:
    #
    # before_run do
    #   clear :terminal
    # end
    #
    def before_run(&block)
      @before_callback = block
    end
    
    # Callback method to run anything you want, after the run the test suite command
    # 
    # Example:
    #
    # after_run do
    #   # some code that I want to run after all the rubies run
    # end
    #
    def after_run(&block)
      @after_callback = block
    end
    
    # Return true if the user set the cucumber option or otherwise return false
    #
    def use_cucumber?
      @cucumber
    end
    
    # Clear the terminal (Useful in the before callback)
    #
    def clear(option)
      system('clear') if option == :terminal
    end
    
  end
end

class NotificationFrameworkDontSupported < StandardError
end

def infinity_test(&block)
  configuration = InfinityTest.configuration
  configuration.instance_eval(&block)
  configuration
end
