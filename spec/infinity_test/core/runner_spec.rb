require 'spec_helper'

module InfinityTest
  describe Runner do
    describe "#options" do
      it "should return an Options instance" do
        Runner.new('--ruby', 'rvm').options.should be_instance_of(Options)
      end
    end

    describe "#base" do
      it "should be the infinity test base class" do
        Runner.new.base.should be InfinityTest::Base
      end
    end
  end
end