module InfinityTest
  class Configuration

    SUPPORTED_FRAMEWORKS = [:growl, :lib_notify] # :snarl, :lib_notify

    attr_accessor :notification_framework, 
    :sucess_image, :failure_image, :pending_image, 
    :rubies, :test_framework, :app_framework,
    :exceptions_to_ignore, 
    :before_callback, :before_each_ruby_callback, :before_environment_callback,
    :after_callback, :after_each_ruby_callback,
    :verbose

    IMAGES_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'images'))

    SUCESS  = 'sucess'
    FAILURE = 'failure'
    PENDING = 'pending'

    # Initialize the Configuration object that keeps the images, callbacks, rubies
    # and the test framework
    # 
    def initialize
      @default_dir_image = File.join(IMAGES_DIR, 'simpson')
      @test_framework = :test_unit
      @app_framework = :rubygems
      @sucess_image  = search_image(SUCESS)
      @failure_image = search_image(FAILURE)
      @pending_image = search_image(PENDING)
      @verbose = false
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
    # notifications :lib_notify
    #
    def notifications(framework, &block)
      message = "Notification :#{framework} don't supported. The Frameworks supported are: #{SUPPORTED_FRAMEWORKS.join(',')}"
      raise NotificationFrameworkDontSupported, message unless SUPPORTED_FRAMEWORKS.include?(framework)
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
      @sucess_image  = options[:sucess]  || search_image(SUCESS)
      @failure_image = options[:failure] || search_image(FAILURE)
      @pending_image = options[:pending] || search_image(PENDING)
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

    # Search the sucess, failure or pending images and return the first in the pattern
    #
    def search_image(file)
      Dir.glob(File.join(@default_dir_image, file) + '*').first
    end

    # The options method to set:
    #
    # * test framework 
    # * ruby versions
    # * verbose mode
    # * app_framework
    # 
    # Here is the example of Little Domain Language:
    #
    # use :rubies => ['1.9.1', '1.9.2'], :test_framework => :rspec
    #
    # use :rubies => [ '1.8.7-p249', '1.9.2@rails3'], :test_framework => :test_unit
    #
    # use :test_framework => :rspec, :app_framework => :rails
    #
    def use(options={})
      rubies = options[:rubies]
      @rubies = (rubies.is_a?(Array) ? rubies.join(',') : rubies) || []
      @test_framework = options[:test_framework] || @test_framework
      @app_framework  = options[:app_framework]  || @app_framework
      @verbose        = options[:verbose]        || @verbose
      setting_gemset_for_each_rubies(options[:gemset]) if options[:gemset]
    end
    
    def setting_gemset_for_each_rubies(gemset)
      @rubies = @rubies.split(',').collect { |ruby| ruby << "@#{gemset}" }.join(',')
    end
      
    # InfinityTest try to use bundler if Gemfile is present.
    # This method tell to InfinityTest to not use this convention.
    #
    def skip_bundler!
      @skip_bundler = true
    end
    
    # Return false if you want the InfinityTest run with bundler
    #
    def skip_bundler?
      @skip_bundler ? true : false
    end
    
    # Method to use to ignore some dir/files changes
    # 
    # Example:
    #
    # ignore :exceptions => %w(.svn .hg .git vendor tmp config rerun.txt)
    #
    # This is useless right now in the Infinity Test because the library 
    # only monitoring lib and test/spec/feature folder.
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
    
    # Callback method to run anything you want, before the environment is fully set up
    # 
    # Example:
    #
    # before_env do |application|
    #   # some code that I want to run before the environment is set up
    # end
    #
    def before_env(&block)
      @before_environment_callback = block
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
    
    # Callback method to handle before or after all run and for each ruby too!
    #
    # Example:
    #
    # before(:all) do
    #   clear :terminal
    # end
    #
    # before(:each_ruby) do
    #   ...
    # end
    #
    # Or if you pass not then will use :all option
    #
    # before do
    #  clear :terminal
    # end
    #
    #
    def before(hook=:all, &block)
      setting_callback(hook, :all => :@before_callback, :each_ruby => :@before_each_ruby_callback, :env => :@before_environment_callback, &block)
    end
    
    # Callback method to handle before or after all run and for each ruby too!
    #
    # Example:
    #
    # after(:all) do
    #   clear :terminal
    # end
    #
    # after(:each_ruby) do
    #   ...
    # end
    #
    # Or if you pass not then will use :all option
    #
    # after do
    #  clear :terminal
    # end
    #
    def after(hook=:all, &block)
      setting_callback(hook, :all => :@after_callback, :each_ruby => :@after_each_ruby_callback, &block)
    end
    
    # Clear the terminal (Useful in the before callback)
    #
    def clear(option)
      system('clear') if option == :terminal
    end
    
    # Added heuristics to the User application
    #
    def heuristics(&block)
      @heuristics ||= Heuristics.new
      @heuristics.instance_eval(&block)
      @heuristics
    end
    
    # Set #watch methods (For more information see Watchr gem)
    #
    # If don't want the heuristics 'magic'
    #
    def watch(pattern, &block)
      @script ||= InfinityTest.watchr
      @script.watch(pattern, &block)
      @script
    end
    
    private
    
    def setting_callback(hook, callback, &block)
      if hook == :all
        instance_variable_set(callback[:all], block)
      elsif hook == :each_ruby
        instance_variable_set(callback[:each_ruby], block)
      elsif hook == :env
        instance_variable_set(callback[:env], block)
      end
    end

  end
end

class NotificationFrameworkDontSupported < StandardError
end

def infinity_test(&block)
  InfinityTest.configuration.instance_eval(&block)
  InfinityTest.configuration
end
