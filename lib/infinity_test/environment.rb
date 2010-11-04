module InfinityTest
  module Environment
    
    # Run in context of each Ruby Environment, and the Ruby Version
    #
    def environments(&block)
      raise unless block_given?
      RVM.environments(self.rubies).each do |environment|
        ruby_version = environment.environment_name
        block.call(environment, ruby_version)
      end
    end

  end
end