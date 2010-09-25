require 'spec_helper'

module InfinityTest
  describe Configuration do
    before { @config = Configuration.new }
    let(:config) { @config }
    
    describe '#initialize' do
      
      it "should set the test_unit as default test framework" do
        Configuration.new.test_framework.should equal :test_unit
      end
      
    end
    
    describe '#infinity_test' do
      
      it "Infinity test Dsl of config file should yield in the Configuration scope" do
        infinity_test do
          use
        end.class.should equal Configuration
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
      
      it "should set the test unit when not set the test framework" do
        config.use
        config.test_framework.should equal :test_unit
      end
      
      it "should return the test framework" do
        config.use :test_framework => :rspec
        config.test_framework.should equal :rspec
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

  end
end