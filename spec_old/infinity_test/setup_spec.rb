require 'spec_helper'

module InfinityTest
  describe Setup do
    let(:setup) { Setup.new }
    
    describe '#test_framework' do
      it 'should return test unit as defaults' do
        setup.test_framework.should equal :test_unit
      end
      
      it 'should be possible to change the defaults' do
        rspec = Setup.new(:test_framework => :rspec)
        rspec.test_framework.should equal :rspec
      end
    end
    
    describe '#app_framework' do
      it 'should return rubygems as defaults' do
        setup.app_framework.should equal :rubygems
      end
      
      it 'should be possible to change' do
        rails = Setup.new(:app_framework => :rails)
        rails.app_framework.should equal :rails
      end
    end
    
    describe '#verbose' do
      it 'should return false as defaults' do
        setup.verbose.should equal false
      end
      
      it 'should be possible to change' do
        verbose = Setup.new(:verbose => true)
        verbose.verbose.should be_true
      end
    end
    
    describe '#specific_options' do
      it 'should be empty by defaults' do
        setup.specific_options.should be_nil
      end
      
      it 'should be possible to change' do
        specific_options = Setup.new(:specific_options => '-Jix')
        specific_options.specific_options.should == '-Jix'
      end
    end
    
    describe '#cucumber' do
      it 'should set false as defaults' do
        setup.cucumber.should equal(false)
        setup.cucumber?.should equal(false)
      end
      
      it 'should set to true when use cucumber' do
        cucumber = Setup.new(:cucumber => true)
        cucumber.cucumber.should be_true
        cucumber.cucumber?.should be_true
      end
    end
    
    describe '#rubies' do
      it 'should set to empty as defaults' do
        setup.rubies.should == []
      end
      
      it 'should be possible to pass as an Array' do
        setup = Setup.new(:rubies => %w(ree jruby rbx))
        setup.rubies.should == 'ree,jruby,rbx'
      end
      
      it 'should be possible to pass as String' do
        setup = Setup.new(:rubies => 'ree,jruby')
        setup.rubies.should == 'ree,jruby'
      end
    end
    
    describe '#gemset' do
      it 'should set the gemsets to nil as defaults' do
        setup.gemset.should be_nil
      end

      it 'should be possible to change' do
        setup = Setup.new(:gemset => 'infinity')
        setup.gemset.should == 'infinity'
      end

      it 'should add the gemset in all the rubies instances' do
        setup = Setup.new(:rubies => %w(ree jruby), :gemset => 'infinity')
        setup.rubies.should == 'ree@infinity,jruby@infinity'
      end
    end
  end
end