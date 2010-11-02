require 'spec_helper'

module InfinityTest
  module ApplicationLibrary
    describe Rails do
      let(:rails) { Rails.new }
      
      describe '#lib_pattern' do

        it { rails.lib_pattern.should == "^lib/*/(.*)\.rb" }
        
        it "should be possible to change the library pattern" do
          rails.lib_pattern = "^another_lib/*/(.*)\.rb"
          rails.lib_pattern.should == "^another_lib/*/(.*)\.rb"
        end
        
      end

      describe '#test_pattern' do
        
        it "should return the pattern for Test::Unit" do
          rails.test_pattern.should == "^test/*/(.*)_test.rb"
        end
        
        it "should return the pattern for Rspec " do
          stub_application_with_rspec
          rails.test_pattern.should == "^spec/*/(.*)_spec.rb"
        end
        
      end

      describe '#configuration_pattern' do
        
        it "should set to config/application.rb" do
          rails.configuration_pattern.should ==  "^config/application.rb"
        end
        
        it "should possible to change the configuration_pattern" do
          rails.configuration_pattern = "^config/environment.rb"
          rails.configuration_pattern.should == "^config/environment.rb"
        end
        
      end
      
      describe '#routes_pattern' do
        
        it "should return the routes_pattern" do
          rails.routes_pattern.should == "^config/routes\.rb"
        end
        
        it "should be possible to set the routes pattern" do
          rails.routes_pattern = "^config/routes_s\.rb"
          rails.routes_pattern.should == "^config/routes_s\.rb"
        end
        
      end
      
      describe '#fixtures_pattern' do
        
        it "should set the fixtures pattern" do
          rails.fixtures_pattern.should == "^test/fixtures/(.*).yml"
        end
        
        it "should set a diferent fixtures pattern" do
          stub_application_with_rspec
          rails.fixtures_pattern.should == "^spec/fixtures/(.*).yml"
        end
        
      end
      
      describe '#controllers_pattern' do
        
        it "should set the controllers pattern" do
          rails.controllers_pattern.should == "^app/controllers/(.*)\.rb"
        end
        
        it "should be possible to set the controllers pattern" do
          rails.controllers_pattern = "^app/super_controllers/(.*)\.rb"
          rails.controllers_pattern.should == "^app/super_controllers/(.*)\.rb"
        end
        
      end
      
      describe '#models_pattern' do
        it "should set the controllers pattern" do
          rails.models_pattern.should == "^app/models/(.*)\.rb"
        end
        
        it "should be possible to set the controllers pattern" do
          rails.models_pattern = "^app/super_models/(.*)\.rb"
          rails.models_pattern.should == "^app/super_models/(.*)\.rb"
        end
        
      end
     
    end
  end
end