require 'spec_helper'
module InfinityTest
  describe Rails do
    before(:each) do
      @app=application_with(:app_framework => :rails)
      @rails=Rails.new :test_framework => @app.test_framework
    end
    it "should  the instance of test framework" do
      @rails.test_framework.should be_instance_of(@app.test_framework.class)
    end

  end
end