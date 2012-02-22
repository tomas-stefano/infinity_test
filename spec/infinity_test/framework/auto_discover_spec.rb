require 'spec_helper'

module InfinityTest
  module Framework
    describe AutoDiscover do
      subject { AutoDiscover.new(Core::Base) }
      it_should_behave_like 'an infinity test framework'

      describe "#heuristics" do
        it "should find framework and rerun the #add_heuristics method" do
          mock(subject).find_framework { :rails }
          mock(subject.base).add_heuristics { true }
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
          mock(framework = Object.new).run? { true }
          mock(framework).framework_name { :rails }
          framework
        end

        let(:dont_run) do
          mock(framework = Object.new).run? { false }
          framework
        end

        it "should return the framework name" do
          mock(Base).subclasses { [dont_run, rails] }
          subject.find_framework.should equal :rails
        end

        it "should raise exception when don't find any framework to add heuristics" do
          mock(Base).subclasses { [dont_run] }
          expect { subject.find_framework }.to raise_exception
        end
      end
    end
  end
end