require 'spec_helper'

module InfinityTest
  module TestLibrary
    describe Bacon do
      let(:current_env) { RVM.current }

      before do
        @current_dir = Dir.pwd
      end

      it "should be possible to set all rubies" do
        Bacon.new(:rubies => '1.9.1').rubies.should be == '1.9.1'
      end

      it "should set the rubies" do
        Bacon.new(:rubies => 'jruby,ree').rubies.should be == 'jruby,ree'
      end

      it "rubies should be empty when not have rubies" do
        Bacon.new.rubies.should be_empty
      end

      it 'should set a default test pattern when have none' do
        Bacon.new.test_pattern.should == 'spec/**/*_spec.rb'
      end

      it "should return false for #pending method" do
        Bacon.new.pending?.should be_false
      end

      describe '#test_files' do

        let(:bacon) { Bacon.new }

        it "return should include the spec files" do
          Dir.chdir("#{@current_dir}/spec/factories/buzz") do
            bacon.test_files.should be == "spec/buzz_spec.rb"
          end
        end

        it "return should include the spec files to test them" do
          Dir.chdir("#{@current_dir}/spec/factories/wood") do
            bacon.test_files.should be == "spec/wood_spec.rb"
          end
        end

        it "return should include the spec files to test them in two level of the spec folder" do
          Dir.chdir("#{@current_dir}/spec/factories/slinky") do
            bacon.test_files.should be == "spec/slinky/slinky_spec.rb"
          end
        end

      end

      describe '#decide_files' do

        before { @bacon = Bacon.new }

        it "should not call the spec file when match pattern" do
          @bacon.should_not_receive(:test_files)
          @bacon.decide_files('application_spec.rb')
        end

        it "should call the spec files when pattern is nil" do
          @bacon.should_receive(:test_files)
          @bacon.decide_files(nil)
        end

      end

      describe '#handle_results' do

        before do
          @bacon = Bacon.new
        end

        it "should handle a example that succeed" do
          results = "should be true\n\n2 specifications (2 requirements), 0 failures, 0 errors\n"
          @bacon.parse_results(results)
          @bacon.message.should == "2 specifications (2 requirements), 0 failures, 0 errors"
        end

        it "should parse without the terminal ansi color" do
          results = "should be true\n\n3 specifications (2 requirements), 0 failures, 0 errors\n"
          @bacon.parse_results(results)
          @bacon.message.should == "3 specifications (2 requirements), 0 failures, 0 errors"
        end

        it "should handle a example that succeed and return false for failure?" do
          results = "3 specifications (2 requirements), 0 failures, 0 errors"
          @bacon.parse_results(results)
          @bacon.failure?.should equal false
        end

        it "should parse without the terminal ansi color and grep the failure" do
          results = "\n\e[33m3 specifications (2 requirements), 10 failures, 0 errors\e[0m\n"
          @bacon.parse_results(results)
          @bacon.failure?.should be_true
        end

        it "should parse bacon tests errors" do
          results = "/Users/tomas/.rvm/gems/ruby-1.9.2@infinity_test/gems/my_class/bin/klass:2:in `require': no such file to load -- MyClass (LoadError)"
          @bacon.parse_results(results)
          @bacon.message.should == "An exception occurred"
        end

        it "should parse bacon tests errors" do
          results = "/Users/tomas/.rvm/gems/ruby-1.9.2@infinity_test/gems/my_class/bin/klass:2:in `require': no such file to load -- MyClass (LoadError)"
          @bacon.parse_results(results)
          @bacon.failure?.should be_true
        end

        it "should parse bacon tests errors" do
          results = "/Users/tomas/.rvm/gems/ruby-1.9.2@infinity_test/gems/my_class/bin/klass:2:in `require': no such file to load -- MyClass (LoadError)"
          @bacon.parse_results(results)
          @bacon.sucess?.should equal false
        end
      end

      describe '#sucess?' do
        before { @bacon = Bacon.new }

        it "should return false when have failures" do
          results = "3 specifications (3 requirements), 3 failures, 0 errors"
          @bacon.parse_results(results)
          @bacon.sucess?.should equal false
        end

        it "should return true when have zero failures and zero pending" do
          results = "13 specifications (20 requirements), 0 failures, 0 errors"
          @bacon.parse_results(results)
          @bacon.sucess?.should be_true
        end

      end

      describe '#search_bacon' do
        # humm ... Bacon ... nhame nhame =]

        it "should match bacon in the string" do
          current_env.should_receive(:path_for).and_return('bacon')
          Bacon.new.search_bacon(current_env).should match /bacon/
        end

        it "should match bacon in the string" do
          current_env.should_receive(:path_for).and_return('bacon')
          Bacon.new.binary_search(current_env).should match /bacon/
        end

      end

      describe '#defaults' do
        it 'should added the load path' do
          Bacon.new.defaults.should == %{-I"lib:spec"}
        end
      end

    end
  end
end
