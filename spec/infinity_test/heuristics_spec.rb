require 'spec_helper'

module InfinityTest
  describe Heuristics do
    
    before do
      @application = application_with_rspec
      InfinityTest.stub!(:watchr).and_return(Watchr::Script.new)
      InfinityTest.stub!(:application).and_return(@application)
      @heuristics = Heuristics.new
    end
      
    describe '#initialize' do
      
      it "should create the patterns instance of Hash" do
        @heuristics.patterns.should be_instance_of(Hash)
      end
      
      it "should create the script instance variable" do
        @heuristics.script.should be_instance_of(Watchr::Script)
      end
      
      it "should have empty rules" do
        @heuristics.script.rules.should be_empty
      end
      
    end
    
    describe '#add' do
      
      it "should add the watch method and persist the pattern" do
        @heuristics.add("^lib/*/(.*)\.rb")
        @heuristics.script.rules.should have(1).items
      end
      
      it "should add the pattern to #patterns instance" do
        @heuristics.add(/^(test|spec)\/fixtures\/(.*).yml$/)
        @heuristics.should have_pattern(/^(test|spec)\/fixtures\/(.*).yml$/)
      end
      
      it "should add other pattern to #patterns instance" do
        @heuristics.add("^lib/*/(.*)\.rb")
        @heuristics.should have_pattern("^lib/*/(.*)\.rb")
      end
      
      it "should add the block object to #patterns instance" do
        proc = Proc.new { 'a' }
        @heuristics.add("^lib/*/(.*)\.rb", &proc)
        @heuristics.patterns.should have_value(proc)
      end
      
    end

    describe '#all' do
      
      it "should return all the patterns" do
        @heuristics.add('^lib/*_spec.rb')
        @heuristics.all.should eql ['^lib/*_spec.rb']
      end
      
      it "should return all the patterns the InfinityTest will watch" do
        @heuristics.add('^config/application.rb')
        @heuristics.add('^spec/spec_helper.rb')
        @heuristics.all.should eql ['^config/application.rb', '^spec/spec_helper.rb']
      end
      
    end
    
    describe '#run' do
      
      let(:binary_path_match_data) { match_data = /(infinity_test\/binary_path)/.match('infinity_test/binary_path') }
            
      it "should call the contruct commands for test file" do
        @application.should_receive(:run_commands_for_file).with('spec/infinity_test/binary_path_spec.rb')
        @heuristics.run(:test_for => binary_path_match_data)
      end
      
      it "should run all the test files" do
        @application.should_receive(:run_commands_for_file).with(@application.all_test_files.join(' '))
        @heuristics.run(:all => :files)
      end
      
    end

    describe '#remove' do
      
      before do
        @heuristics.add('^lib/*/(.*)_spec.rb')
        @heuristics.add('^spec/*/(.*)_spec.rb')
      end
      
      it { @heuristics.patterns.should have(2).items }
      
      it { @heuristics.script.rules.should have(2).items }
      
      it "should remove the pattern from patterns" do
        @heuristics.remove('^lib/*/(.*)_spec.rb')
        @heuristics.should_not have_pattern('^lib/*/(.*)_spec.rb')
      end
      
      it "should remove the rules from watchr" do
        @heuristics.remove('^lib/*/(.*)_spec.rb')
        @heuristics.script.rules.should have(1).items
      end
      
      it "should remove all the rules from watchr" do
        @heuristics.remove :all
        @heuristics.script.rules.should be_empty
      end
      
      it "should remove all the patterns" do
        @heuristics.remove :all
        @heuristics.patterns.should be_empty
      end
      
    end
   
  end
end