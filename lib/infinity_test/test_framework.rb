module InfinityTest
  class TestFramework
    attr_accessor :message

    def self.parse_results(patterns)
      raise(ArgumentError, 'patterns should not be empty') if patterns.empty?
      patterns.each do |attribute, pattern|
        attr_accessor attribute
      end
      define_method(:parse_results) do |results|
        shell_result = test_message(results)
        if shell_result =~ /example/ or shell_result =~ /tests/
          create_pattern_instance_variables(patterns, shell_result)
        else
          @message = "An exception occurred"
        end
      end
    end
    
    def create_pattern_instance_variables(patterns, shell_result)
      patterns.each do |key, pattern|
        instance_variable_set("@#{key}", shell_result[pattern, 1].to_i)
      end
      @message = shell_result
    end
    
    def test_message(output)
      output.split("\n").last
    end
    
  end
end