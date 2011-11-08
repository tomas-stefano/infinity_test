module InfinityTest
  class Setup
    attr_accessor :rubies, :test_framework, :app_framework, :verbose, :specific_options, :cucumber, :gemset
    alias :cucumber? :cucumber

    def initialize(options={})
      @test_framework   = options[:test_framework]   || :test_unit
      @app_framework    = options[:app_framework]    || :rubygems
      @verbose          = options[:verbose]          || false
      @specific_options = options[:specific_options] || nil
      @cucumber         = options[:cucumber]         || false
      @rubies = (options[:rubies].is_a?(Array) ? options[:rubies].join(',') : options[:rubies]) || []
      @gemset = options[:gemset]
      setting_gemset_for_each_ruby(options[:gemset]) if options[:gemset]
    end
    
    # Setting a gemset for each rubies
    #
    # setting_gemset_for_each_rubies('infinity_test') # => ['1.8.7@infinity_test', '1.9.2@infinity_test']
    #
    def setting_gemset_for_each_ruby(rvm_gemset)
      @rubies = if @rubies.respond_to?(:split)
        @rubies.split(',').collect { |ruby| ruby << "@#{gemset}" }.join(',')
      end
    end
  end
end