require 'spec_helper'

module InfinityTest
  describe TestUnit do
    
    before(:each) do
      @current_dir = Dir.pwd
    end
    
    it "should be possible to set all rubies" do
      TestUnit.new(:rubies => 'jruby').rubies.should be == 'jruby'
    end
    
    it "should be possible to set any rubies that I want" do
      TestUnit.new(:rubies => 'ree,1.9.1,1.9.2').rubies.should be == 'ree,1.9.1,1.9.2'
    end
    
    it "should have the test directory pattern" do
      TestUnit.new(:rubies => 'ree,1.9.1').test_directory_pattern.should be == "^test/(.*)_test.rb"
    end

    let(:test_unit) { TestUnit.new }

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