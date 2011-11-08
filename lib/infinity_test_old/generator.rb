module InfinityTest
  class Generator
    attr_reader :options
    def initialize(configuration_options)
      @options = configuration_options
      create_file '.infinity_test'
    end
    
    def create_file(infinity_test_file)
      write_only_and_binary_mode = 'wb'
      context = instance_eval('binding')
      File.open(infinity_test_file, write_only_and_binary_mode) do |file|
        file.write(ERB.new(::File.binread(template), nil, '-', '@output_buffer').result(context))
      end
    end
    
    def template
      File.join(File.dirname(__FILE__), 'template.erb')
    end
    
    def look_options_for_use_method!
      options_to_use = {}
      options_to_use[:test_framework] = options[:test_framework] if options[:test_framework]
      options_to_use[:app_framework] = options[:app_framework] if options[:app_framework]
      options_to_use[:verbose] = options[:verbose] if options[:verbose]
      options_to_use[:skip_bundler] = options[:skip_bundler] if options[:skip_bundler]
      options_to_use[:rubies] = options[:rubies] if options[:rubies]
      "use(#{options_to_use})"
    end

  end
end