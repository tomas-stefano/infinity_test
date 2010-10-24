require 'spec_helper'

module InfinityTest
  describe ContinuousTesting do
    
    it "should keep the application object" do
      ContinuousTesting.new.application.should equal InfinityTest.application
    end
    
    it "should keep the watchr object" do
      ContinuousTesting.new.watchr.should equal InfinityTest.watchr
    end
    
  end
end