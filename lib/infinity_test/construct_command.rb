module InfinityTest
  class ConstructCommand
    attr_accessor :command, :application, :test_framework, :binary_name, :files_to_run

    attr_reader :version
    include InfinityTest::Environment
    include InfinityTest::BinaryPath

    def initialize(options={})
      @application = InfinityTest.application
      @test_framework = @application.test_framework
      @command = {}
      @files_to_run = options[:files_to_run] || []
    end

    # Create all commands for each ruby
    #
    def create
      environments do |environment, ruby_version|
        build_command do |ruby_command|
          ruby_command.version = ruby_version
          ruby_command.binary_for(environment)
          ruby_command.build!
        end
      end
      self
    end

    # If the user dont pass rubies then will use only the current ruby
    #
    def rubies
      versions_to_run = application.rubies
      if versions_to_run.empty?
        current_environment_name
      else
        versions_to_run
      end
    end

    # Just a method to become more easier to understand the intention of logic
    #
    def build_command(&block)
      block.call(self)
    end

    # Adding a ruby version as a key in the Hash
    #
    def version=(ruby_version)
      @command[ruby_version] = ''
      @version = ruby_version
    end

    # Call binary of rspec two, rspec one or bacon, if using test unit return nothing
    #
    def binary_for(environment)
      if test_framework.respond_to?(:binary_search)
        @binary_name = application.binary_search(environment)
        print_message(binary_name, version) unless have_binary?(binary_name)
      end
    end

    # Build command for each ruby
    # Run with bundler if the application have a gemfile and the user don't want to skipped
    # Run without bundler otherwise
    #
    def build!
      @command[version] = lambda do
        if run_with_bundler?
          run_with_bundler
        else
          run_without_bundler
        end
      end.call
    end

    def run_with_bundler
      if application.using_test_unit?
        %{bundle exec #{defaults} #{files_to_test}}
      else
        %{#{defaults} -S bundle exec #{binary_name} #{files_to_test}}
      end
    end

    def run_without_bundler
      if application.using_test_unit?
        %{#{defaults} #{files_to_test}}
      else
        %{#{defaults} -S #{binary_name} #{files_to_test}}
      end
    end

    def defaults
      cmd = %{rvm #{version} ruby}
      cmd << %{#{ruby_options}} if ruby_options
      cmd
    end

    def ruby_options
      options = ""
      options << " #{specific_options}" if specific_options
      options << %{ #{test_framework.defaults}} if test_framework.respond_to?(:defaults)
      options
    end

    def specific_options
      options = application.specific_options
       if options
         %{#{options}} unless options.empty?
       end
    end

    # If have files to run means that user changed a file and only that file needs to run right now
    # Otherwise is full run and will run all tests
    #
    def files_to_test
      if files_to_run.empty?
        test_framework.test_files
      else
        files_to_run
      end
    end

    private

      def run_with_bundler?
        application.have_gemfile? and using_bundler?
      end

      def using_bundler?
        not application.skip_bundler?
      end

  end
end