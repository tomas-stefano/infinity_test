require 'spec_helper'
require 'ostruct'

module InfinityTest
  module Strategy
    describe Base do
      let(:subject) { 
        base_object = Object.new
        mock(base_object).strategy { :rvm }
        Base.new(base_object)
      }

      describe ".subclasses" do
        it "should have rvm, rbenv, rubydefault and autodiscover as subclasses" do
          Base.subclasses.should include(Rbenv, Rvm, RubyDefault, AutoDiscover)
        end
      end

      describe ".sort_by_priority" do
        let(:low_priority) { OpenStruct.new(:priority => :very_low) }
        let(:high_priority) { OpenStruct.new(:priority => :high) }
        let(:normal_priority) { OpenStruct.new(:priority => :normal) }
        let(:regular_priority) { OpenStruct.new(:priority => :regular) }

        it "should sort the subclasses by the high priority first" do
          mock(Base).subclasses { [ low_priority, high_priority, regular_priority, normal_priority] }
          Base.sort_by_priority.should == [high_priority, normal_priority, regular_priority, low_priority]
        end
      end

      describe ".priority" do
        it "should return middle priority as default" do
          Base.priority.should equal :normal
        end
      end

      describe "#run!" do
        it "should raise Not Implemented Error" do
          lambda { 
            subject.run!
          }.should raise_exception(NotImplementedError)
        end
      end

      describe "#strategy_name" do
        it "should return the name of the strategy" do
          Rvm.strategy_name.should be :rvm
        end

        it "should return the name of the strategy as undercore" do
          RubyDefault.strategy_name.should be :ruby_default
        end
      end

      describe ".run?" do
        it "should raise Not Implemented Error" do
          lambda { 
            Base.run?
          }.should raise_exception(NotImplementedError)
        end
      end
    end
  end
end
