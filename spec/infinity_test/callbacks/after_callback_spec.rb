require "spec_helper"

module InfinityTest
  describe AfterCallback do
    describe "#scope" do
      it "should keep the scope" do
        AfterCallback.new(:all).scope.should be :all
      end

      it "should set each scope" do
        AfterCallback.new(:each).scope.should be :each
      end
    end

    describe "#block" do
      let(:proc) { Proc.new {} }
      it "should keep the proc object to call later" do
        AfterCallback.new(:each, &proc).block.should be proc
      end
    end
  end
end