require 'spec_helper'

module InfinityTest
  describe Command do

    it "should pass the ruby version and set" do
      Command.new(:ruby_version => '1.9.2').ruby_version.should == '1.9.2'
    end

    it "should pass the ruby version and set" do
      Command.new(:ruby_version => 'JRuby 1.3.5').ruby_version.should == 'JRuby 1.3.5'
    end

    it "should create and set the command" do
      Command.new(:command => 'rspec spec').command.should == 'rspec spec'
    end

    it "should create and set the command for ruby version" do
      Command.new(:command => 'spec spec').command.should == 'spec spec'
    end

    it "should have the results as Array" do
      Command.new.results.should be_instance_of(Array)
    end

    it "should have the line variable as Array" do
      Command.new.line.should be_instance_of(Array)
    end

    describe '#push_in_the_results' do

      before do
        @command = Command.new
      end

      it "should parse correct the results when have in the ree" do
        @command.line = [27, 91, 51, 51, 109, 49, 50, 49, 32, 101, 120, 97, 109, 112, 108, 101, 115, 44, 32, 48, 32, 102, 97, 105, 108, 117, 114, 101, 115, 44, 32, 50, 32, 112, 101, 110, 100, 105, 110, 103, 27, 91, 48, 109, 10]
        @command.should_receive(:yarv?).and_return(false)
        @command.push_in_the_results(?\n)
        @command.results.should == ["\e[33m121 examples, 0 failures, 2 pending\e[0m\n"]
      end

      it "should parse correct the results in ruby 1.8" do
        @command.line = [46, 46, 46, 46, 46, 42, 46, 42]
        @command.should_receive(:yarv?).and_return(false)
        @command.push_in_the_results(?\n)
        @command.results.should == [".....*.*"]
      end

    end

  end
end
