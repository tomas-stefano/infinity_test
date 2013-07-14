require 'spec_helper'

module InfinityTest
  module Core
    describe ContinuousTestServer do
      let(:continuous_test_server) { ContinuousTestServer.new(Core::Base) }

      describe '#start' do
        it 'auto discover user libraries' do
          Core::AutoDiscover.any_instance.should_receive(:discover_libraries)
          continuous_test_server.start
        end
      end
    end
  end
end