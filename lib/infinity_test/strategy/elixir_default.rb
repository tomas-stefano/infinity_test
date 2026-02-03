module InfinityTest
  module Strategy
    class ElixirDefault < Base
      attr_reader :continuous_test_server
      delegate :binary, :test_files, to: :continuous_test_server

      def run!
        command = "#{binary} test #{test_files}"
        command = "#{command} #{Core::Base.specific_options}" if Core::Base.specific_options.present?
        command
      end

      # Run when the project has mix.exs (Elixir project)
      #
      def self.run?
        File.exist?('mix.exs')
      end
    end
  end
end
