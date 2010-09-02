require 'spec_helper'

module InfinityTest
  describe Configuration do
    include Configuration
    
    describe '#notifications' do
      
      it "should possible to set the growl notification framework" do
        notifications :growl
        notification_framework.should equal :growl
      end
      
      it "should possible to set the snarl notification framework" do
        notifications :snarl
        notification_framework.should equal :snarl
      end
      
      it "should possible to set the lib notify notification framework" do
        notifications :lib_notify
        notification_framework.should equal :lib_notify
      end
      
      it "should not possible to set another notification framework" do
        lambda { notifications(:dont_exist) }.should raise_exception(NotificationFrameworkDontSupported, "Notification :dont_exist don't supported. The Frameworks supported are: growl,snarl,lib_notify")
      end
      
      it "should raise exception for non supported notification framework" do
        lambda { notifications(:snarfff) }.should raise_exception(NotificationFrameworkDontSupported, "Notification :snarfff don't supported. The Frameworks supported are: growl,snarl,lib_notify")
      end
      
    end

    describe '#run_with' do
      
      it "should set the rvm versions" do
        run_with :rvm => ['1.8.7-p249']
        rvm_versions.should be == ['1.8.7-p249']
      end
      
      it "should set many ruby versions" do
        run_with :rvm => ['1.9.1', '1.9.2']
        rvm_versions.should be == ['1.9.1', '1.9.2']
      end
      
      it "should return a empty collection when not set the rvm option" do
        run_with :cucumber => true
        rvm_versions.should be_empty
      end
      
      it "should set the cucumber option" do
        run_with :cucumber => true
        use_cucumber?.should be_true
      end
      
      it "should return the false object when not use cucumber" do
        run_with :rvm => []
        use_cucumber?.should equal false
      end
      
      it "should set the test unit when not set the test framework" do
        run_with
        test_framework.should equal :test_unit
      end
      
      it "should return the test framework" do
        run_with :test_framework => :rspec
        test_framework.should equal :rspec
      end
      
      it "should possible to set the test unit for test framework" do
        run_with :test_framework => :test_unit
        test_framework.should equal :test_unit
      end
      
    end

    describe '#ignore' do
      
      it "should be empty when not have dir/files to ignore" do
        ignore
        exceptions_to_ignore.should be == []
      end
      
      it "should set the exception to ignore" do
        ignore :exceptions => %w(.svn)
        exceptions_to_ignore.should be == %w(.svn)
      end
      
      it "should set the exceptions to ignore changes" do
        ignore :exceptions => %w(.svn .hg .git vendor tmp config rerun.txt)
        exceptions_to_ignore.should be == %w(.svn .hg .git vendor tmp config rerun.txt)
      end
      
    end

    describe '#before_run' do
      
      it "should persist the proc object in the before callback" do
        proc = Proc.new { 'To Infinity and beyond!' }
        before_run(&proc)
        before_callback.should be == proc
      end
      
    end
    
    describe '#after_run' do
      
      it "should persist the proc object in the after callback" do
        proc = Proc.new { 'To Infinity and beyond!' }
        after_run(&proc)
        after_callback.should be == proc
      end
      
    end

  end
end