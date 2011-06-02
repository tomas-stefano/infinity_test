module InfinityTest
  module Environment

    # Run in context of each Ruby Environment, and the Ruby Version
    #
    # This method assumes that the class/module that is included has a method called rubies
    #
    def environments(&block)
      raise unless block_given?
      RVM.environments(rubies).each do |environment|
        ruby_version = environment.environment_name
        block.call(environment, ruby_version)
      end
    end

  end
end
