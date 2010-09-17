require 'spec_helper'

module InfinityTest
  describe ContinuousTesting do

  describe '#initialize' do
    
    it "should be possible to set the Rspec class test framework" do
      continuous_testing = ContinuousTesting.new(:application => application_with_rspec)
      continuous_testing.test_framework.should be_instance_of(InfinityTest::Rspec)
    end
    
    it "should be possible to set the TestUnit class test framework" do
      continuous_testing = ContinuousTesting.new(:application => application_with_test_unit)
      continuous_testing.test_framework.should be_instance_of(InfinityTest::TestUnit)
    end
     
    it "should initialize a empty Hash results" do
      ContinuousTesting.new(:application => application_with_rspec).results.should == {}
    end
    
    it "should pass all the rubies for the Rspec class when test framework is Rspec" do
      Rspec.should_receive(:new).with({:rubies => '1.9.1,jruby'})
      ContinuousTesting.new(:application => application_with(:rubies => %w(1.9.1 jruby), :test_framework => :rspec)).test_framework
    end
    
    it "should pass all the rubies for the TestUnit class when test framework is TestUnit" do
      TestUnit.should_receive(:new).with({:rubies => '1.9.1,jruby'})
      ContinuousTesting.new(:application => application_with(:rubies => %w(1.9.1 jruby), :test_framework => :test_unit)).test_framework
    end
    
  end

  describe '#parse_results_and_show_notification!' do
    
    it "should parse the results for the rspec" do
      continuous_testing = continuous_testing_with(new_application(:test_framework => :rspec, :notifications => :growl))
      Notifications::Growl.should_receive(:notify)
      continuous_testing.parse_results_and_show_notification!(:results => "....\n105 examples, 0 failures, 0 pending", :ruby_version => '1.9.2')
    end
    
  end

  describe '#image_to_show' do
    let(:continuous_testing_with_rspec) { ContinuousTesting.new(:application => application_with_rspec) }
    
    it "should return sucess when pass all the tests" do
      test_should_not_fail!(continuous_testing_with_rspec)
      test_should_not_pending!(continuous_testing_with_rspec)
      continuous_testing_with_rspec.image_to_show.should match /sucess/
    end

    it "should return failure when not pass all the tests" do
      test_should_fail!(continuous_testing_with_rspec)
      continuous_testing_with_rspec.image_to_show.should match /failure/
    end

    it "should return pending when have pending tests" do
      test_should_not_fail!(continuous_testing_with_rspec)
      test_should_pending!(continuous_testing_with_rspec)
      continuous_testing_with_rspec.image_to_show.should match /pending/
    end
    
    def test_should_not_fail!(object)
      object.test_framework.should_receive(:failure?).and_return(false)      
    end

    def test_should_fail!(object)
      object.test_framework.should_receive(:failure?).and_return(true)
    end
    
    def test_should_pending!(object)
      object.test_framework.should_receive(:pending?).and_return(true)      
    end
    
    def test_should_not_pending!(object)
      object.test_framework.should_receive(:pending?).and_return(false)      
    end
    
  end

  end
end