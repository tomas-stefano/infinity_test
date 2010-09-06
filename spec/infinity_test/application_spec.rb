require 'spec_helper'

module InfinityTest
  describe Application do
    
    before(:each) do
      @application = Application.new
    end
   
    describe '#load_configuration_file' do
      
      it "should read the configuration file and assign properly the rvm versions" do
        read_and_load_home_config :file => 'spec/factories/infinity_test_example'
        @application.rubies.should be == '1.8.7-p249,1.9.1'
      end
      
      it "should read the home configuration file and assign the rvm versions" do
        read_and_load_home_config :file => 'spec/factories/infinity_test'
        @application.rubies.should be == '1.8.7-p249,1.9.1,1.9.2'
      end
      
      it "should read the home configuration file and assign the test framework" do
        read_and_load_home_config :file => 'spec/factories/infinity_test'
        @application.test_framework.should equal :rspec
      end
      
      it "should read the home configuration file and assign the test framework properly" do
        read_and_load_home_config :file => 'spec/factories/infinity_test_example'
        @application.test_framework.should equal :test_unit
      end
      
      it "should read the home configuration file and assign the cucumber library" do
        read_and_load_home_config :file => 'spec/factories/infinity_test'
        @application.cucumber?.should be_true
      end
      
      it "should read the home configuration file and assign the cucumber library as false when not have cucumber option" do
        read_and_load_home_config :file => 'spec/factories/infinity_test_example'
        @application.cucumber?.should equal false
      end

    end
    
  end
end