require 'spec_helper'

module InfinityTest
  describe Runner do
    let(:runner) { Runner.new('--ruby', 'rvm') }

    describe '#start' do
      it 'load configuration, merge with command line, find user libraries and start continuous server' do
        expect_any_instance_of(Core::LoadConfiguration).to receive(:load!)
        expect(Core::Base).to receive(:merge!).with(runner.options)
        expect_any_instance_of(Core::AutoDiscover).to receive(:discover_libraries)
        expect_any_instance_of(ContinuousTestServer).to receive(:start)
        runner.start
      end
    end
  end
end