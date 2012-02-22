module InfinityTest
  module Framework
    class Rails < Base
      def heuristics
        # @observer.watch_dir('app') do |file|
        #   RunFile.new(file)
        # end
        #
        # @observer.watch('Gemfile') do
        #   bundle_install
        #   RunAll.new
        # end
        #
        # @observer.watch @test_framework.test_helper_file do
            # RunAll.new
        # end
      end

      def self.run?
        File.exist?(File.expand_path('./config/environment.rb'))
      end
    end
  end
end