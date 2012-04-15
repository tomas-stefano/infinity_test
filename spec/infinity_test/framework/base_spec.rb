require 'spec_helper'

module InfinityTest
  module Framework
    describe Base do
      subject { Base.new(Core::Base) }

      describe ".subclasses" do
        it "should have rvm, rbenv, rubydefault and autodiscover as subclasses" do
          Base.subclasses.should include(Rails, Padrino, Rubygems, AutoDiscover)
        end
      end

      describe ".framework_name" do
        it "should return the framework name demodulized" do
          Rails.framework_name.should be :rails
        end

        it "should return the framework name downcased" do
          Rubygems.framework_name.should be :rubygems
        end

        it "should return with underscore" do
          AutoDiscover.framework_name.should be :auto_discover
        end
      end

      describe "#test_framework" do
        it "should be instance of Test Framework" do
          subject.test_framework.should be_instance_of(TestFramework::AutoDiscover)
        end
      end

      describe "#observer" do
        it "should be instance of a infinity test observer" do
          subject.observer.should be_instance_of(Observer::Watchr)
        end
      end

      describe "#strategy" do
        it "should be instance of a infinity test auto discover" do
          subject.strategy.should be_instance_of(Strategy::AutoDiscover)
        end
      end
    end
  end
end