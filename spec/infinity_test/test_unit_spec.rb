require 'spec_helper'

module InfinityTest
  describe TestUnit do
    
    before(:each) do
      @current_dir = Dir.pwd
    end
    
    let(:test_unit) { TestUnit.new }

    describe "#build_command_string" do
            
      it "should use ruby" do
        test_unit.build_command_string(nil).should match /^ruby/
      end
      
      it "should not use rvm when not have ruby versions" do
        test_unit.build_command_string(nil).should_not match /^rvm/
      end
      
      it "should use rvm command with many ruby versions" do
        test_unit.build_command_string('1.8.7').should match /^rvm 1.8.7 ruby/
      end
      
      it "should be possible to use many versions of ruby" do
        test_unit.build_command_string('1.8.6,1.8.7').should match /^rvm 1.8.6,1.8.7 ruby/
      end
      
      it "should include the lib and test directory" do
        test_unit.build_command_string('1.8.6,1.8.7').should include("ruby -Ilib:test")
      end
      
    end
    
    describe "#test_loader" do
      
      it "should call files to test with test_loader" do
        Dir.chdir("#{@current_dir}/spec/factories/travel") do
          test_unit.test_loader.should eql "#{@current_dir}/lib/infinity_test/test_unit_loader.rb"
        end
      end
      
      context "should call more than one file to test with test_loader" do

        it "return should include test/company_test.rb" do
          Dir.chdir("#{@current_dir}/spec/factories/company") do
            test_unit.collect_test_files.should eql ["test/company_test.rb"]
          end
        end

        it "return should include more than one file to test" do
          Dir.chdir("#{@current_dir}/spec/factories/travel") do
            test_unit.collect_test_files.should eql ["test/partner_test.rb","test/travel_test.rb"]
          end
        end
        
      end
    end
    
  end
end