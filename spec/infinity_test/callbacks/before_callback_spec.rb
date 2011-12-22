require "spec_helper"

module InfinityTest
  describe BeforeCallback do
    describe "#scope" do
      it "should keep the scope" do
        BeforeCallback.new(:all).scope.should be :all
      end

      it "should set each scope" do
        BeforeCallback.new(:each).scope.should be :each
      end
    end

    describe "#block" do
      let(:proc) { Proc.new {} }
      it "should keep the proc object to call later" do
        BeforeCallback.new(:each, &proc).block.should be proc
      end
    end
  end
end