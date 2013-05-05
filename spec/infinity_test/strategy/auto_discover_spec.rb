require "spec_helper"

module InfinityTest
  module Strategy
    describe AutoDiscover do
      subject { AutoDiscover.new(Core::Base) }
      it_should_behave_like 'a infinity test strategy'

      describe "#run!" do
        it "should find strategy and rerun the discovered strategy" do
          subject.should_receive(:find_strategy)
          subject.base.should_receive(:run_strategy!).and_return(true)
          subject.run!
        end
      end

      describe ".run?" do
        it "should not run because this class discover the right strategy" do
          AutoDiscover.should_not be_run
        end
      end

      describe "#find_strategy" do
        let(:to_be_run) do
          klass = Object.new
          klass.stub(:run?).and_return(true)
          klass.stub(:strategy_name).and_return(:rvm)
          klass
        end

        let(:to_not_run) do
          klass = Object.new
          klass.stub(:run?).and_return(false)
          klass
        end

        it "should return the strategy name for the class that returns true on method .run?" do
          Base.should_receive(:sort_by_priority).and_return([ to_be_run, mock ])
          subject.find_strategy.should equal :rvm
        end

        it "should raise exception when don't find any class to run" do
          Base.should_receive(:sort_by_priority).and_return([to_not_run])
          expect { subject.find_strategy }.to raise_exception
        end
      end
    end
  end
end
