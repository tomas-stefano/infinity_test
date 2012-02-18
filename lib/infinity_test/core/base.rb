module InfinityTest
  module Core
    class Base
      # Specify the Ruby Version Manager to run
      cattr_accessor :strategy
      # ==== Options
      # * :rvm
      # * :rbenv
      # * :ruby_normal (Use when don't pass any rubies to run)
      # * :auto_discover(defaults)
      self.strategy = :auto_discover

      # Specify Ruby version(s) to test against
      # ==== Examples
      # rubies = %w(ree jruby)
      #
      cattr_accessor :rubies
      self.rubies = []

      # Options to include in the command.
      #
      cattr_accessor :specific_options
      self.specific_options = ''

      # Test Framework to use Rspec, Bacon, Test::Unit or AutoDiscover(defaults)
      # ==== Options
      # * :rspec
      # * :bacon
      # * :test_unit (Test unit here apply to this two libs: test/unit and minitest)
      # * :auto_discover(defaults)
      #
      # This will load a exactly a class constantize by name.
      #
      cattr_accessor :test_framework
      self.test_framework = :auto_discover

      # Framework to know the folders and files that need to monitoring by the observer.
      #
      # ==== Options
      # * :rails
      # * :rubygems
      # * :auto_discover(defaults)
      #
      # This will load a exactly a class constantize by name.
      #
      cattr_accessor :framework
      self.framework = :auto_discover

      # Framework to observer watch the dirs.
      #
      # ==== Options
      #  * watchr
      #
      cattr_accessor :observer
      self.observer = :watchr

      # Verbose Mode. Print commands before executing them.
      #
      cattr_accessor :verbose
      self.verbose = true

      # Set the notification framework to use with Infinity Test.
      #
      # ==== Options
      # * :growl
      # * :lib_notify
      # * :auto_discover(defaults)
      #
      # This will load a exactly a class constantize by name.
      #
      cattr_accessor :notification
      self.notification = :auto_discover

      # You can set directory to show images matched by the convention names.
      # => http://github.com/tomas-stefano/infinity_test/tree/master/images/ )
      #
      # Infinity test will work on these names in the notification framework:
      #
      # * success (png, gif, jpeg)
      # * failure (png, gif, jpeg)
      # * pending (png, gif, jpeg)
      #
      cattr_accessor :mode
      # => This will show images in the folder:
      # http://github.com/tomas-stefano/infinity_test/tree/master/images/simpson
      self.mode = :simpson 

      # Success Image to show after the tests run.
      cattr_accessor :success_image

      # Pending Image to show after the tests run.
      cattr_accessor :pending_image

      # Failure Image to show after the tests run.
      cattr_accessor :failure_image

      # Use a specific gemset for each ruby
      cattr_accessor :gemset

      # InfinityTest try to use bundler if Gemfile is present.
      # Set to false if you don't want use bundler
      cattr_accessor :bundler
      self.bundler = true

      # Callbacks accessor to handle before or after all run and for each ruby!
      cattr_accessor :callbacks
      self.callbacks = []

      # Setup Infinity Test passing the ruby versions and others setting.
      # See the class accessors for more information.
      #
      # ==== Examples
      #
      #  InfinityTest::Base.setup do |config|
      #    config.strategy = :rbenv
      #    config.rubies   = %w(ree jruby rbx 1.9.2)
      #  end
      #
      def self.setup
        yield self
      end

      # Receives a object that quacks like InfinityTest::Options and do the merge with self(Base class).
      #
      def self.merge!(options)
        ConfigurationMerge.new(self, options).merge!
      end

      # Returns the class for the configured strategy.
      #
      def self.strategy_class
        ::InfinityTest::Strategy.const_get(strategy.to_s.classify)
      end

      # Returns the instance for the configured strategy.
      #
      def self.ruby_strategy
        strategy_class.new(self)
      end

      # Run strategy based on the choosed ruby strategy.
      #
      def self.run_strategy!
        ruby_strategy.run!
      end

      # Start to monitoring files in the project
      #
      def self.start_observer
        observer_instance.start
      end

      def self.framework_instance
        # Framework.const_get(framework.to_s.classify).new(observer_instance, test_framework_instance, ruby_strategy)
      end

      def self.observer_instance
        Observer.const_get(observer.to_s.classify).new
      end

      # Callback method to handle before all run and for each ruby too!
      #
      # ==== Examples
      #
      #   before(:all) do
      #     # ...
      #   end
      #
      #   before(:each_ruby) do
      #     # ...
      #   end
      #
      #   before do # if you pass not then will use :all option
      #     # ...
      #   end
      #
      def self.before(scope, &block)
        setting_callback(Callbacks::BeforeCallback, scope, &block)
      end

      # Callback method to handle after all run and for each ruby too!
      #
      # ==== Examples
      #
      #   after(:all) do
      #     # ...
      #   end
      #   
      #   after(:each_ruby) do
      #     # ...
      #   end
      #   
      #   after do # if you pass not then will use :all option
      #     # ...
      #   end
      #
      def self.after(scope, &block)
        setting_callback(Callbacks::AfterCallback, scope, &block)
      end

      # Clear the terminal (Useful in the before callback)
      #
      def self.clear_terminal
        system('clear')
      end

      ###### This methods will be removed in the Infinity Test v2.0.1 ######

      # <b>DEPRECATED:</b> Please use <tt>.notification=</tt> instead.
      #
      def self.notifications(notification_name, &block)
        ActiveSupport::Deprecation.warn(".notifications is DEPRECATED. Use .notification= instead.")
        self.notification = notification_name
        self.instance_eval(&block) if block_given?
      end

      # <b>DEPRECATED:</b> Please use:
      # <tt>success_image=</tt> or
      # <tt>pending_image=</tt> or
      # <tt>failure_image=</tt> or
      # <tt>mode=</tt> instead.
      #
      def self.show_images(options)
        message = '.show_images is DEPRECATED. Use .success_image= or .pending_image= or .failure_image= or .mode= instead'
        ActiveSupport::Deprecation.warn(message)
        self.success_image = options[:success_image] || options[:sucess_image] if options[:success_image].present? || options[:sucess_image].present? # for fail typo in earlier versions.
        self.pending_image = options[:pending_image] if options[:pending_image].present?
        self.failure_image = options[:failure_image] if options[:failure_image].present?
        self.mode = options[:mode] if options[:mode].present?
      end

      # <b>DEPRECATED:</b> Please use:
      # .rubies= or 
      # .specific_options= or 
      # .test_framework= or 
      # .framework= or 
      # .verbose= or 
      # .gemset= instead
      #
      def self.use(options)
        message = '.use is DEPRECATED. Please use .rubies= or .specific_options= or .test_framework= or .framework= or .verbose= or .gemset= instead.'
        ActiveSupport::Deprecation.warn(message)
        self.rubies = options[:rubies] if options[:rubies].present?
        self.specific_options = options[:specific_options] if options[:specific_options].present?
        self.test_framework = options[:test_framework] if options[:test_framework].present?
        self.framework = options[:app_framework] if options[:app_framework].present?
        self.verbose = options[:verbose] unless options[:verbose].nil?
        self.gemset = options[:gemset] if options[:gemset].present?
      end

      # <b>DEPRECATED:</b> Please use .clear_terminal instead.
      #
      def self.clear(option)
        message = '.clear(:terminal) is DEPRECATED. Please use .clear_terminal instead.'
        ActiveSupport::Deprecation.warn(message)
        clear_terminal
      end

      def self.heuristics(&block)
        # ... There is a spec pending.
      end

      def self.replace_patterns(&block)
        # ... There is a spec pending.
      end

      private

      def self.setting_callback(callback_class, scope, &block)
        callback_instance = callback_class.new(scope, &block)
        self.callbacks.push(callback_instance)
        callback_instance
      end
    end
  end
end