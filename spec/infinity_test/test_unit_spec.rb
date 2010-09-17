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
      TestUnit.new(:rubies => 'ree,1.9.1').test_directory_pattern.should be == "^test/*/(.*)_test.rb"
    end
    
    it "should be empty when not have rubies" do
      TestUnit.new.rubies.should be == []
    end

    describe "#test_loader" do
      let(:test_unit) { TestUnit.new }
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
    
    describe '#construct_commands' do
      
    it "should return a Hash when not have rubies" do
        TestUnit.new.construct_commands.should be_instance_of(Hash)
      end
      
      it "should have the command ruby with lib and test in the load path" do
        TestUnit.new.construct_commands.first.last.should match /ruby -I'lib:test'/
      end
      
      it "should call construct_rubies_commands when have rubies" do
        test_unit = TestUnit.new(:rubies => '1.9.1')
        test_unit.should_receive(:construct_rubies_commands)
        test_unit.construct_commands
      end
      
      it "should not call construct_rubies_commands when not have rubies" do
        test_unit = TestUnit.new
        test_unit.should_not_receive(:construct_rubies_commands)
        test_unit.construct_commands
      end
      
    end
    
  end
    
    describe '#parse_results' do
      
      before do
        @test_unit = TestUnit.new
      end
      
      it "should parse when have all passed" do
        results = ".....\n3 tests, 3 assertions, 0 failures, 0 errors, 0 skips"
        @test_unit.parse_results(results)
        @test_unit.message.should == "3 tests, 3 assertions, 0 failures, 0 errors, 0 skips"
      end
      
      it "should parse when have extra message (in Ruby 1.9.*)" do
        results = "\nFinished in 0.001742 seconds.\n\n3 tests, 3 assertions, 1 failures, 1 errors, 1 skips\n\nTest run options: --seed 18841\n"
        @test_unit.parse_results(results)
        @test_unit.message.should == "3 tests, 3 assertions, 1 failures, 1 errors, 1 skips"
      end

      it "should parse when have a exception" do
        @test_unit.parse_results("")
        @test_unit.message.should == "An exception ocurred"
      end
            
    end
    
end