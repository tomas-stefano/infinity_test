require 'spec_helper'

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
