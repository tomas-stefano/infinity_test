require 'erb'
module InfinityTest
  class Generator
    
    def initialize(options)
      @options = options
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

  end
end