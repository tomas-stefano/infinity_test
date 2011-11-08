require 'spec_helper'

module InfinityTest
  describe ContinuousTesting do
    let(:continuous_testing) { ContinuousTesting.new }
    it "should keep the application object" do
      continuous_testing.application.should equal InfinityTest.application
    end

    it "should keep the watchr object" do
      continuous_testing.watchr.should equal InfinityTest.watchr
    end

    describe '#initialize_watchr!' do

      it "should call add_signal and run_with_watchr!" do
        continuous_testing.should_receive(:add_signal)
        continuous_testing.should_receive(:run_with_watchr!)
        continuous_testing.initialize_watchr!
      end

    end

  end
end
