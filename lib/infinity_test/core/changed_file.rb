module InfinityTest
  module Core
    class ChangedFile
      attr_accessor :match_data, :name, :path

      def initialize(match_data)
        @match_data = match_data
        @name       = match_data.to_s
        @path       = match_data[1]
      end
    end
  end
end