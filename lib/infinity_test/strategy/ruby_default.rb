module InfinityTest
  module Strategy
    class RubyDefault < Base
      attr_reader :continuous_test_server
      delegate :binary, :test_files, to: :continuous_test_server

      def run!
        command = "#{binary} #{test_files}"
        with_bundler(command)
      end

      # ==== Returns
      #  TrueClass: If the user don't pass the ruby versions to run tests.
      #  FalseClass: If the user pass some ruby version to run tests.
      #
      def self.run?
        Core::Base.rubies.blank?
      end
    end
  end
end