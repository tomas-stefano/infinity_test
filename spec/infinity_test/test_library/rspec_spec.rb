require 'spec_helper'

module InfinityTest
  module TestLibrary    
    describe Rspec do
      before do
        @current_dir = Dir.pwd
      end
      
      it "should be possible to set all rubies" do
        Rspec.new(:rubies => '1.9.1').rubies.should be == '1.9.1'
      end
      
      it "should set the rubies" do
        Rspec.new(:rubies => 'jruby,ree').rubies.should be == 'jruby,ree'
      end
      
      it "rubies should be empty when not have rubies" do
        Rspec.new.rubies.should be_empty
      end
      
      it "should have the pattern for spec directory" do
        Rspec.new.test_directory_pattern.should be == "^spec/*/(.*)_spec.rb"
      end
      
      it 'should set a default test pattern when have none' do
        Rspec.new.test_pattern.should == 'spec/**/*_spec.rb'
      end
      
      describe '#test_files' do
        
        let(:rspec) { Rspec.new }
        
        it "return should include the spec files" do
          Dir.chdir("#{@current_dir}/spec/factories/buzz") do
            rspec.test_files.should be == "spec/buzz_spec.rb"
          end
        end
        
        it "return should include the spec files to test them" do
          Dir.chdir("#{@current_dir}/spec/factories/wood") do
            rspec.test_files.should be == "spec/wood_spec.rb"
          end
        end
        
        it "return should include the spec files to test them in two level of the spec folder" do
          Dir.chdir("#{@current_dir}/spec/factories/slinky") do
            rspec.test_files.should be == "spec/slinky/slinky_spec.rb"
          end
        end
        
      end
    
      describe '#decide_files' do
        
        before { @rspec = Rspec.new }
        
        it "should not call the spec file when match pattern" do
          @rspec.should_not_receive(:test_files)
          @rspec.decide_files('application_spec.rb')
        end
    
        it "should call the spec files when pattern is nil" do
          @rspec.should_receive(:test_files)
          @rspec.decide_files(nil)
        end
        
      end
    
      describe '#handle_results' do
        
        before do
          @rspec = Rspec.new
        end
        
        it "should handle a example that succeed" do
          results = "........Finished in 0.299817 seconds\n\n105 examples, 0 failures, 0 pending\n"
          @rspec.parse_results(results)
          @rspec.message.should == "105 examples, 0 failures, 0 pending"
        end
        
        it "should parse without the terminal ansi color" do
          results = "ork\e[0m\n\e[90m    # No reason given\e[0m\n\e[90m    # ./spec/infinity_test/configuration_spec.rb:31\e[0m\n\nFinished in 0.10487 seconds\n\e[33m406 examples, 5 failures, 2 pending\e[0m\n"
          @rspec.parse_results(results)
          @rspec.message.should == "406 examples, 5 failures, 2 pending"
        end
    
        it "should handle a example that succeed and return false for failure?" do
          results = "........Finished in 0.299817 seconds\n\n105 examples, 0 failures, 0 pending\n"
          @rspec.parse_results(results)
          @rspec.failure?.should equal false
        end
        
        it "should parse without the terminal ansi color and grep the failure" do
          results = "ork\e[0m\n\e[90m    # No reason given\e[0m\n\e[90m    # ./spec/infinity_test/configuration_spec.rb:31\e[0m\n\nFinished in 0.10487 seconds\n\e[33m406 examples, 5 failures, 2 pending\e[0m\n"
          @rspec.parse_results(results)
          @rspec.failure?.should be_true
        end
    
        it "should parse without the terminal ansi color and grep the pending" do
          results = "ork\e[0m\n\e[90m    # No reason given\e[0m\n\e[90m    # ./spec/infinity_test/configuration_spec.rb:31\e[0m\n\nFinished in 0.10487 seconds\n\e[33m406 examples, 0 failures, 2 pending\e[0m\n"
          @rspec.parse_results(results)
          @rspec.pending?.should be_true
        end
    
        it "should parse rspec tests errors" do
          results = "/Users/tomas/.rvm/gems/ruby-1.9.2@infinity_test/gems/my_class/bin/klass:2:in `require': no such file to load -- MyClass (LoadError)"
          @rspec.parse_results(results)
          @rspec.message.should == "An exception occurred"
        end
    
        it "should parse rspec tests errors" do
          results = "/Users/tomas/.rvm/gems/ruby-1.9.2@infinity_test/gems/my_class/bin/klass:2:in `require': no such file to load -- MyClass (LoadError)"
          @rspec.parse_results(results)
          @rspec.failure?.should be_true
        end
    
        it "should parse rspec tests errors" do
          results = "/Users/tomas/.rvm/gems/ruby-1.9.2@infinity_test/gems/my_class/bin/klass:2:in `require': no such file to load -- MyClass (LoadError)"
          @rspec.parse_results(results)
          @rspec.sucess?.should equal false
        end
    
        it "should parse rspec tests errors" do
          results = "/Users/tomas/.rvm/gems/ruby-1.9.2@infinity_test/gems/my_class/bin/klass:2:in `require': no such file to load -- MyClass (LoadError)"
          @rspec.parse_results(results)
          @rspec.pending?.should equal false
        end            
      end
      
      describe '#sucess?' do
        before { @rspec = Rspec.new }
        
        it "should return false when have failures" do
          results = "ork\e[0m\n\e[90m    # No reason given\e[0m\n\e[90m    # ./spec/infinity_test/configuration_spec.rb:31\e[0m\n\nFinished in 0.10487 seconds\n\e[33m406 examples, 5 failures, 2 pending\e[0m\n"
          @rspec.parse_results(results)
          @rspec.sucess?.should equal false
        end
    
        it "should return false when have pending" do
          results = "ork\e[0m\n\e[90m    # No reason given\e[0m\n\e[90m    # ./spec/infinity_test/configuration_spec.rb:31\e[0m\n\nFinished in 0.10487 seconds\n\e[33m806 examples, 0 failures, 2 pending\e[0m\n"
          @rspec.parse_results(results)
          @rspec.sucess?.should be_false
        end
        
        it "should return true when have zero failures and zero pending" do
          results = "........Finished in 0.299817 seconds\n\n105 examples, 0 failures, 0 pending\n"
          @rspec.parse_results(results)
          @rspec.sucess?.should be_true
        end
        
      end
      
      describe '#pending?' do
        let(:rspec) { Rspec.new }
        
        it "should return true when have pending" do
          rspec.pending = 1
          rspec.failures = 0
          rspec.pending?.should be_true
        end
    
        it "should return false when have pending bu thave failures" do
          rspec.pending = 1
          rspec.failures = 1
          rspec.pending?.should equal false
        end
        
      end
      
      describe '#search_rspec_one' do
        
        it { InfinityTest::TestLibrary::Rspec.new.search_rspec_one(current_env).should match /spec\z/ }
        
      end
      
      describe '#search_rspec_two' do
        it { InfinityTest::TestLibrary::Rspec.new.search_rspec_two(current_env).should match /rspec\z/ }
      end

      describe '#construct_rubies_commands' do

        before(:all) do
          @rspec = Rspec.new
          @rspec.application.stub(:have_gemfile?).and_return(false)
          @command = @rspec.construct_commands
        end
        
        it "should return a Hash" do
          @command.should be_instance_of(Hash)
        end
        
        it "should return the rvm with the environment name" do
          first_element(@command).should match /^rvm #{environment_name}/
        end
        
        it "should include ruby command" do
          first_element(@command).should =~ / ruby /
        end
        
        it "should include bacon(nhame nhame) in the command" do
          first_element(@command).should =~ /\/rspec /
        end
        
        it "should include the files to test" do
          first_element(@command).should match /_spec.rb/
        end
        
        it "should not include bundle exec when Gemfile is not present" do
          application_without_gemfile(@rspec.application)
          first_element(@rspec.construct_commands).should_not =~ /\/bundle exec /          
        end
        
        it "should include bundle exec when Gemfile is present" do
          application_with_gemfile(@rspec.application)
          first_element(@rspec.construct_commands).should =~ /\/bundle exec /
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