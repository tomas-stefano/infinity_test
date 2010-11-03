require 'spec_helper'

module InfinityTest
  describe Configuration do
    before { @config = Configuration.new }
    let(:config) { @config }
    let(:block) { Proc.new { 'To Infinity and beyond!' } }

    describe '#initialize' do
      
      it "should set the test_unit as default test framework" do
        Configuration.new.test_framework.should equal :test_unit
      end
      
    end
    
    describe '#heuristics' do
      
      it "should return a instance of Heuristics class" do
        config.heuristics do
        end.should be_instance_of(InfinityTest::Heuristics)
      end
      
      it "should be possible to add heuristics to the application" do
        heuristics = config.heuristics do
          add("^lib/*/(.*)\.rb") do |file|
          end
        end
        heuristics.should have_pattern("^lib/*/(.*)\.rb")
      end
      
      it "should cache the heuristics instance variable" do
        heuristics = config.heuristics do
        end
        same_heuristics = config.heuristics do
        end
        heuristics.should equal same_heuristics
      end
    end

    describe '#watch' do
      
      it "should evaluate in the watchr script class" do
        config.watch("^lib/*/(.*)\.rb") do |file|
          do_something!
        end.should equal InfinityTest.watchr
      end
      
    end
    
    describe '#notifications' do
      
      it "should possible to set the growl notification framework" do
        config.notifications :growl
        config.notification_framework.should equal :growl
      end
      
      it "should possible to set the lib notify notification framework" do
        config.notifications :lib_notify
        config.notification_framework.should equal :lib_notify
      end
      
      it "should not possible to set another notification framework" do
        lambda { config.notifications(:dont_exist) }.should raise_exception(NotificationFrameworkDontSupported, "Notification :dont_exist don't supported. The Frameworks supported are: growl,lib_notify")
      end
      
      it "should raise exception for non supported notification framework" do
        lambda { config.notifications(:snarfff) }.should raise_exception(NotificationFrameworkDontSupported, "Notification :snarfff don't supported. The Frameworks supported are: growl,lib_notify")
      end
      
    end

    describe '#use' do
      
      it "should set the rvm versions" do
        config.use :rubies => '1.8.7-p249'
        config.rubies.should be == '1.8.7-p249'
      end
      
      it "should set many ruby versions" do
        config.use :rubies => ['1.9.1', '1.9.2']
        config.rubies.should be == '1.9.1,1.9.2'
      end
      
      it "should set the gemset and change all rubies" do
        config.use :rubies => ['1.9.1', '1.9.2'], :gemset => 'infinity_test'
        config.rubies.should be == '1.9.1@infinity_test,1.9.2@infinity_test'
      end

      it "should set the gemset and change all rubies" do
        config.use :rubies => ['1.9.1', '1.9.2'], :gemset => 'other_gemset'
        config.rubies.should be == '1.9.1@other_gemset,1.9.2@other_gemset'
      end

      it "should set many ruby versions with nil gemset key" do
        config.use :rubies => ['1.9.1', '1.9.2'], :gemset => nil
        config.rubies.should be == '1.9.1,1.9.2'
      end
            
      it "should set the test unit when not set the test framework" do
        config.use
        config.test_framework.should equal :test_unit
      end
      
      it "should return the test framework" do
        config.use :test_framework => :rspec
        config.test_framework.should equal :rspec
      end
      
      it "should return bacon too for the test framework" do
        config.use :test_framework => :bacon
        config.test_framework.should equal :bacon
      end
      
      it "should possible to set the test unit for test framework" do
        config.use :test_framework => :test_unit
        config.test_framework.should equal :test_unit
      end
      
      it "should set the verbose option" do
        config.use :verbose => true
        config.verbose.should be_true
      end
      
      it "should set to false as default" do
        config.verbose.should equal false
      end
      
      it "should be possible to use Rails framework" do
        config.use :app_framework => :rails
        config.app_framework.should equal :rails
      end
      
      it "should set the rubygems as default app framework" do
        config.use
        config.app_framework.should equal :rubygems
      end
      
      it "should be possible to set the cucumber option" do
        config.use :cucumber => true
        config.cucumber?.should be_true
      end
      
      it "should be false as default" do
        config.cucumber?.should be_false
      end
      
    end

    describe '#skip_bundler!' do
      
      it "should return true if skip bundler" do
        config.skip_bundler!
        config.skip_bundler?.should be_true
      end
      
      it "should return false if not skip bundler (default)" do
        config.skip_bundler?.should be_false
      end
      
    end

    describe '#ignore' do
      
      it "should be empty when not have dir/files to ignore" do
        config.ignore
        config.exceptions_to_ignore.should be == []
      end
      
      it "should set the exception to ignore" do
        config.ignore :exceptions => %w(.svn)
        config.exceptions_to_ignore.should be == %w(.svn)
      end
      
      it "should set the exceptions to ignore changes" do
        config.ignore :exceptions => %w(.svn .hg .git vendor tmp config rerun.txt)
        config.exceptions_to_ignore.should be == %w(.svn .hg .git vendor tmp config rerun.txt)
      end
      
    end

    describe '#show_images' do
      
      before { @config = Configuration.new }
      
      let(:config) { @config }
      
      context 'on default images' do
        before { @config.notifications :growl }
          
        it { config.sucess_image.should == image('simpson/sucess.jpg') }
        
        it { config.pending_image.should == image('simpson/pending.jpg') }
        
        it { config.failure_image.should == image('simpson/failure.gif') }
        
      end
      
      context 'on setting my own image' do
        before { config.notifications :lib_notify }
          
        it "should be possible to customize success image" do
          config.show_images :sucess => image('other.png')
          config.sucess_image.should == image('other.png')
        end

        it "should be possible to customize failure image" do
          config.show_images :failure => image('failure_picture.png')
          config.failure_image.should == image('failure_picture.png')
        end

        it "should be possible to customize failure image" do
          config.show_images :pending => image('pending_picture.png')
          config.pending_image.should == image('pending_picture.png')
        end
      end
      
      context 'setting the dirrectory image or modes' do
        before { config.notifications :growl }
        
        it "should possible to change the dir of images" do
          config.show_images :mode => :street_fighter
          config.pending_image.should == image('street_fighter/pending.gif')
        end

        it "should possible to change the dir of the images" do
          config.show_images :mode => :toy_story
          config.sucess_image.should == image('toy_story/sucess.png')
        end

        it "should possible to change the dir of the images" do
          config.show_images :mode => custom_image_dir
          config.sucess_image.should == custom_image('images/sucess.png')
        end
      end
    end

    describe '#before_run' do
      
      it "should persist the proc object in the before callback" do
        proc = Proc.new { 'To Infinity and beyond!' }
        config.before_run(&proc)
        config.before_callback.should be == proc
      end
      
    end
    
    describe '#after_run' do
      
      it "should persist the proc object in the after callback" do
        proc = Proc.new { 'To Infinity and beyond!' }
        config.after_run(&proc)
        config.after_callback.should be == proc
      end
      
    end

    describe '#before' do
      
      it "should set the before callback if pass not hook" do
        config.before(&block)
        config.before_callback.should == block
      end
      
      it "should possible to set the before_run block" do
        config.before(:all, &block)
        config.before_callback.should == block
      end
      
      it "should possible to set before each ruby block" do
        config.before(:each_ruby, &block)
        config.before_each_ruby_callback.should == block
      end
      
      it "should not set before_run block in :each_ruby option" do
        config.before(:each_ruby, &block)
        config.before_callback.should be_nil
      end

      it "should not set before_run block in :all option" do
        config.before(:all, &block)
        config.before_each_ruby_callback.should be_nil
      end
      
    end

    describe '#after' do
      
      it "should set the after callback if pass not hook" do
        config.after(&block)
        config.after_callback.should == block
      end
      
      it "should possible to set the after block" do
        config.after(:all, &block)
        config.after_callback.should == block
      end
      
      it "should possible to set after each ruby block" do
        config.after(:each_ruby, &block)
        config.after_each_ruby_callback.should == block
      end
      
      it "should not set after block in :each_ruby option" do
        config.after(:each_ruby, &block)
        config.after_callback.should be_nil
      end

      it "should not set after each ruby block in :all option" do
        config.after(:all, &block)
        config.after_each_ruby_callback.should be_nil
      end
      
    end

    describe '#replace_patterns' do
      
      it "should evaluate in the context of application framework" do
        config.replace_patterns do |application_framework, application|
        end.should be_instance_of(InfinityTest::ApplicationLibrary::RubyGems)
      end
      
      it "should return the same object match in the InfinityTest.application.app_framework" do
        config.replace_patterns do |application_framework, application|
        end.should equal InfinityTest.application.app_framework        
      end
      
      it "should replace patterns to the application framework" do
        config.replace_patterns do |application_framework, application|
          application_framework.lib_pattern = "^lib/(.*)\.rb"
        end
        InfinityTest.application.app_framework.lib_pattern.should == "^lib/(.*)\.rb"
      end
      
      it "should replace patterns and replace the test pattern to test framework lookup" do
        config.replace_patterns do |application_framework, application|
          application_framework.test_pattern = "^my_unusual_spec_directory/unit/(.*)_spec.rb"
          application.test_framework.test_pattern = "my_unusual_spec_directory/unit/*_spec.rb"
        end
        InfinityTest.application.app_framework.test_pattern.should == "^my_unusual_spec_directory/unit/(.*)_spec.rb"
        InfinityTest.application.test_framework.test_pattern.should == "my_unusual_spec_directory/unit/*_spec.rb"
      end
      
    end
  
  end
end

describe '#infinity_test' do
  it 'should return a instance of Configuration class' do
    infinity_test do
    end.should be_instance_of(InfinityTest::Configuration)
  end
  
  it "Infinity test Dsl of config file should yield in the Configuration scope" do
    infinity_test do
      use
    end.class.should equal InfinityTest::Configuration
  end
  
end
