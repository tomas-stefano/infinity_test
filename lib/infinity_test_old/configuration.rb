module InfinityTest
  class Configuration
    extend Forwardable

    attr_accessor :notification, :setup, :exceptions_to_ignore, :before_callback, :after_callback,
    :before_each_ruby_callback, :before_environment_callback, :after_each_ruby_callback

    def_delegator :@notification, :sucess_image, :sucess_image
    def_delegator :@notification, :pending_image, :pending_image
    def_delegator :@notification, :failure_image, :failure_image    
    def_delegator :@notification, :notifier, :notification_framework

    def_delegator :@setup, :test_framework, :test_framework
    def_delegator :@setup, :app_framework, :app_framework
    def_delegator :@setup, :verbose, :verbose
    def_delegator :@setup, :specific_options, :specific_options
    def_delegator :@setup, :cucumber, :cucumber
    def_delegator :@setup, :cucumber?, :cucumber?
    def_delegator :@setup, :rubies, :rubies
    def_delegator :@setup, :gemset, :gemset

    # Initialize the Configuration object that keeps the images, callbacks, rubies
    # and the test framework
    #
    def initialize
      @notification = Notification.new
      @setup = Setup.new
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
      @notification = Notification.new(framework, &block)
      self
    end

    # ==== Options
    # :rubies           - Specify Ruby version(s) to test against
    # :specific_options - Specific options to run in a specified ruby
    # :test_framework   - Test Framework to use (Rspec, Bacon, Test::Unit(defaults))
    # :app_framework    - Framework to use (Rails, Rubygems library(defaults))
    # :verbose          - Print commands before executing them
    # :gemset           - Use a specific gemset for each ruby
    # :cucumber         - Use cucumber(experimental feature)
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
      @setup = Setup.new(options)
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
      setting_callback(hook, 
        :all => :@before_callback, 
        :each_ruby => :@before_each_ruby_callback, 
        :env => :@before_environment_callback, &block)
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

    def replace_patterns(&block)
      block.call(InfinityTest.application)
      InfinityTest.application
    end
    alias :before_env :replace_patterns

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
