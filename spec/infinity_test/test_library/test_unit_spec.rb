require 'spec_helper'

module InfinityTest
  module TestLibrary
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
              test_unit.all_files.should eql ["test/company_test.rb"]
            end
          end
    
          it "return should include more than one file to test" do
            Dir.chdir("#{@current_dir}/spec/factories/travel") do
              test_unit.all_files.should eql ["test/partner_test.rb","test/travel_test.rb"]
            end
          end
          
          it "should include all the tests file" do
            Dir.chdir("#{@current_dir}/spec/factories/travel") do
              test_unit.test_files.should include "test/partner_test.rb test/travel_test.rb"
            end
          end
          
          it "should include test loader" do
            Dir.chdir("#{@current_dir}/spec/factories/travel") do
              test_unit.test_files.should include "#{@current_dir}/lib/infinity_test/test_unit_loader.rb"
            end            
          end
          
        end
      end
      
      describe '#construct_commands' do
        
        it "should return a Hash when not have rubies" do
          TestUnit.new.construct_commands.should be_instance_of(Hash)
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
          @test_unit.message.should == "An exception occurred"
        end
        
        it "should parse and set correctly the tests" do
          results = "\nFinished in 0.8981 seconds.\n\n3 tests, 3 assertions, 1 failures, 1 errors, 1 skips\n\nTest run options: --seed 18841\n"
          @test_unit.parse_results(results)
          @test_unit.tests.should == 3
        end
    
        it "should parse and set correctly the tests" do
          results = "\nFinished in 0.5678 seconds.\n\n6 tests, 3 assertions, 1 failures, 1 errors, 1 skips\n\nTest run options: --seed 18841\n"
          @test_unit.parse_results(results)
          @test_unit.tests.should == 6
        end
    
        it "should parse and set correctly the tests" do
          results = "\nFinished in 0.34678 seconds.\n\n6 tests, 7 assertions, 1 failures, 1 errors, 1 skips\n\nTest run options: --seed 18841\n"
          @test_unit.parse_results(results)
          @test_unit.assertions.should == 7
        end
    
        it "should parse and set correctly the tests" do
          results = "\nFinished in 0.8561 seconds.\n\n3 tests, 4 assertions, 1 failures, 1 errors, 1 skips\n\nTest run options: --seed 18841\n"
          @test_unit.parse_results(results)
          @test_unit.assertions.should == 4
        end
    
        it "should parse and set correctly the tests" do
          results = "\nFinished in 0.7654 seconds.\n\n6 tests, 3 assertions, 4 failures, 1 errors, 1 skips\n\nTest run options: --seed 18841\n"
          @test_unit.parse_results(results)
          @test_unit.failures.should == 4
        end
    
        it "should parse and set correctly the tests" do
          results = "\nFinished in 0.789065 seconds.\n\n6 tests, 3 assertions, 5 failures, 1 errors, 1 skips\n\nTest run options: --seed 18841\n"
          @test_unit.parse_results(results)
          @test_unit.failures.should == 5
        end
        
        it "should parse and set correctly the tests" do
          results = "\nFinished in 0.7654 seconds.\n\n6 tests, 3 assertions, 4 failures, 2 errors, 1 skips\n\nTest run options: --seed 18841\n"
          @test_unit.parse_results(results)
          @test_unit.errors.should == 2
        end
    
        it "should parse and set correctly the tests" do
          results = "\nFinished in 0.7654 seconds.\n\n36 tests, 37 assertions, 4 failures, 20 errors, 1 skips\n\nTest run options: --seed 18841\n"
          @test_unit.parse_results(results)
          @test_unit.errors.should == 20
        end
    
        it "should parse when have a exception and set failure to 1" do
          @test_unit.parse_results("")
          @test_unit.failures.should == 1
          @test_unit.tests.should == 1
          @test_unit.assertions.should == 1
          @test_unit.errors.should == 1
        end
    
      end    
    
      describe '#failure?' do
        
        before do
          @test_unit = TestUnit.new
        end
        
        it "should return true when have failures" do
          @test_unit.parse_results(".....\n3 tests, 3 assertions, 1 failures, 0 errors, 0 skips")
          @test_unit.failure?.should be_true
        end
    
        it "should return true when have errors" do
          @test_unit.parse_results(".....\n3 tests, 3 assertions, 0 failures, 4 errors, 0 skips")
          @test_unit.failure?.should be_true
        end
    
        it "should return true when have nothing" do
          @test_unit.parse_results("")
          @test_unit.failure?.should be_true
        end
        
        it "should return false when have all suceed :) " do
          @test_unit.parse_results(".....\n3 tests, 3 assertions, 0 failures, 0 errors, 0 skips")
          @test_unit.failure?.should be_false
        end
    
        it 'should return false when have all assertions and tests suceed \o/ ' do
          @test_unit.parse_results(".....\n4 tests, 7 assertions, 0 failures, 0 errors, 0 skips")
          @test_unit.failure?.should be_false
        end
        
      end
    
      describe '#pending?' do
        
        it "should be false" do
          TestUnit.new.pending?.should equal false
        end
        
      end

      describe '#construct_rubies_command' do
        before do
          @test_unit = TestUnit.new
          @test_unit.application.stub(:have_gemfile?).and_return(false)
        end
        
        it "should return a Hash" do
          @test_unit.construct_rubies_commands.should be_instance_of(Hash)
        end
        
        it "should return the rvm with the environment name" do
          first_element(@test_unit.construct_commands).should match /^rvm #{environment_name}/
        end
        
        it "should include ruby command" do
          first_element(@test_unit.construct_commands).should =~ / ruby /
        end
        
        it "should include the files to test" do
          first_element(@test_unit.construct_commands).should match /test_unit_loader.rb/
        end
        
        it "should not include bundle exec when Gemfile is not present" do
          application_without_gemfile(@test_unit.application)
          first_element(@test_unit.construct_commands).should_not =~ /\/bundle exec /          
        end
        
        it "should include bundle exec when Gemfile is present" do
          application_with_gemfile(@test_unit.application)
          first_element(@test_unit.construct_commands).should =~ /\/bundle exec /
        end
        
        def first_element(hash, hash_size=1)
          hash.should have(hash_size).item
          command = hash.each { |ruby_version, command_to_run| 
            return command_to_run 
          }
        end
        
      end

    end    
  end
end