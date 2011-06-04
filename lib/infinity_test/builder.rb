module InfinityTest
  module Builder

    #
    # TODO: Refactoring this Ugly Code
    #
    def construct_command(options)
      binary_name, ruby_version, command, file, environment, specific_options = resolve_options(options)

      unless have_binary?(binary_name) || options[:skip_binary?]
        print_message(binary_name, ruby_version)
      else
        command = "#{command} #{decide_files(file)}"
        rvm_ruby_version = "rvm #{ruby_version} ruby #{specific_options}"

	      if application.have_gemfile? and not application.skip_bundler?
          run_with_bundler!(rvm_ruby_version, command, environment)
        else
          run_without_bundler!(rvm_ruby_version, command)
        end
      end
    end

    #
    def run_with_bundler!(rvm_ruby_version, command, environment)
      bundle_binary = search_bundle(environment)
      unless have_binary?(bundle_binary)
        print_message('bundle', environment.expanded_name)
        exit(1)
      else
        %{#{bundle_binary} exec #{rvm_ruby_version} #{command}}
      end
    end

    #
    def run_without_bundler!(rvm_ruby_version, command)
      %{#{rvm_ruby_version} #{command}}
    end

    #
    # Contruct all the Commands for each ruby instance variable
    # If don't want to run with many rubies, add the current ruby to the rubies instance
    # and create the command with current ruby
    #
    def construct_commands(file=nil)
      @rubies << RVM::Environment.current.environment_name if @rubies.empty?
      construct_rubies_commands(file)
    end

    #
    # TODO: Refactoring this Ugly Code
    #
    #
    def resolve_options(options)
      ruby_version = options[:for]
      binary_name = options[:skip_binary?] ? '' : options[:binary]
      load_path = %{-I"#{options[:load_path]}"} if options[:load_path]
      environment = options[:environment]
      file = options[:file]
      specific_options = options[:specific_options]
      command = [ binary_name, load_path].compact.join(' ')
      [binary_name, ruby_version, command, file, environment, specific_options]
    end

  end
end
