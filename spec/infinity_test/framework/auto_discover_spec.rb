require 'spec_helper'

module InfinityTest
  module Framework
    describe AutoDiscover do
      before { pending }
      subject { AutoDiscover.new(Core::Base) }
      it_should_behave_like 'an infinity test framework'

      describe "#heuristics" do
        it "should find framework and rerun the #add_heuristics method" do
          subject.should_receive(:find_framework).and_return(:rails)
          subject.base.should_receive(:add_heuristics).and_return(true)
          subject.heuristics
        end
      end

      describe ".run?" do
        it "should not run because this class discover the right framework" do
          AutoDiscover.should_not be_run
        end
      end

      describe "#find_framework" do
        let(:rails) do
          framework = Object.new
          framework.should_receive(:run?).and_return(true)
          framework.should_receive(:framework_name).and_return(:rails)
          framework
        end

        let(:dont_run) do
          framework = Object.new
          framework.should_receive(:run?).and_return(false)
          framework
        end

        it "should return the framework name" do
          Base.should_receive(:subclasses).and_return([dont_run, rails])
          subject.find_framework.should equal :rails
        end

        it "should raise exception when don't find any framework to add heuristics" do
          Base.should_receive(:subclasses).and_return([dont_run])
          expect { subject.find_framework }.to raise_exception
        end
      end
    end
  end
end