require 'spec_helper'

module InfinityTest
  describe Runner do
    let(:runner) { Runner.new('--ruby', 'rvm') }

    describe '#start' do
      it 'load configuration, merge with command line, find user libraries and start continuous server' do
        Core::LoadConfiguration.any_instance.should_receive(:load!)
        Core::Base.should_receive(:merge!).with(runner.options)
        Core::AutoDiscover.any_instance.should_receive(:discover_libraries)
        ContinuousTestServer.any_instance.should_receive(:start)
        runner.start
      end
    end
  end
end