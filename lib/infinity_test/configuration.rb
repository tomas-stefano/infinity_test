module InfinityTest
  module Configuration
    SUPPORTED_FRAMEWORKS = [:growl, :snarl, :lib_notify]
    
    # Set the notification framework to use with Infinity Test.
    # The supported Notification Frameworks are:
    #
    # * Growl (Mac)
    # * Lib-Notify (Linux/BSD)
    # * Snarl (Windows)
    #
    # Here is the example of little Domain Specific Language to use:
    #
    # notifications :growl do
    #   on :sucess,  :show_image => :default
    #   on :failure, :show_image => 'Users/tomas/images/my_custom_image.png'
    # end
    #
    def notifications(framework)
      raise NotificationFrameworkDontSupported, "Notification :#{framework} don't supported. The Frameworks supported are: #{SUPPORTED_FRAMEWORKS.join(',')}" unless SUPPORTED_FRAMEWORKS.include?(framework)
      @notification_framework = framework
    end
    
    # Return the symbol of Notification Framework
    #
    def notification_framework
      @notification_framework
    end
    
    # The options method to set:
    # * test framework 
    # * ruby versions
    # * use cucumber or not
    # 
    # Here is the example of Little Domain Language:
    #
    # run_with :rvm => ['1.9.1', '1.9.2'], :test_framework => :rspec, :cucumber => true
    #
    # run_with :rvm => [ '1.8.7-p249', '1.9.2@rails3'], :test_framework => :test_unit
    #
    #
    def run_with(options={})
      @rvm_versions = options[:rvm] || []
      @cucumber = options[:cucumber] || false
      @test_framework = options[:test_framework] || :test_unit
    end
    
    # Method to use to ignore some dir/files changes
    # 
    # Example:
    #
    # ignore :exceptions => %w(.svn .hg .git vendor tmp config rerun.txt)
    #
    def ignore(options={})
      @exceptions_to_ignore = options[:exceptions] || []
    end
    
    # Callback method to run anything you want before the run the test suite command
    # 
    # Example:
    #
    # before_run do
    #   system('clear')
    # end
    #
    def before_run(&block)
      @before_callback = block
    end
    
    # Callback method to run anything you want after the run the test suite command
    # 
    # Example:
    #
    # after_run do
    #   # some code here
    # end
    #
    def after_run(&block)
      @after_callback = block
    end
    
    # Return all the ruby versions specified in run_with method
    #
    def rvm_versions
      @rvm_versions
    end
    
    # Return true if the user set the cucumber option or otherwise return false
    #
    def use_cucumber?
      @cucumber
    end
    
    # Return the test framework specified in the run_with method
    #
    def test_framework
      @test_framework
    end
    
    # Return the exceptions to ignore changes in the dir or files specified
    #
    def exceptions_to_ignore
      @exceptions_to_ignore
    end
    
    # Return the block object persisted in the before_run method
    #
    def before_callback
      @before_callback
    end
    
    # Return the block object persisted in the after_run method
    #
    def after_callback
      @after_callback
    end
    
  end
end

class NotificationFrameworkDontSupported < StandardError
end
