require "spec_helper"

module InfinityTest
  module Strategy
    describe AutoDiscover do
      subject { AutoDiscover.new(Core::Base) }
      it_should_behave_like 'a infinity test strategy'

      describe "#run!" do
        it "should find strategy and rerun the discovered strategy" do
          mock(subject).find_strategy
          mock(subject.base).run_strategy! { true }
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
          mock(klass).run? { true }
          mock(klass).strategy_name { :rvm }
          klass
        end

        let(:to_not_run) do
          klass = Object.new
          mock(klass).run? { false }
          klass
        end

        it "should return the strategy name for the class that returns true on method .run?" do
          mock(Base).sort_by_priority { [ to_be_run, mock ] }
          subject.find_strategy.should equal :rvm
        end

        it "should raise exception when don't find any class to run" do
          mock(Base).sort_by_priority { [to_not_run] }
          expect { subject.find_strategy }.to raise_exception
        end
      end
    end
  end
end
