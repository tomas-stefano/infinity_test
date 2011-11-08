require 'spec_helper'

module InfinityTest
  describe Notification do
    let(:growl) { Notification.new(:growl) }
    let(:lib_notify) { Notification.new(:lib_notify)}
    let(:without_any_notifier) { Notification.new }
    
    describe '#notifier' do
      it { growl.notifier.should equal :growl }
      it { lib_notify.notifier.should equal :lib_notify }
      it { without_any_notifier.notifier.should be_nil }
    end
    
    describe '#action' do
      it 'should be optional to pass a block' do
        block = Proc.new { 'a' }
        notification = Notification.new(:growl, &block)
        notification.action.should == block
      end
      it { growl.action.should be_nil }
      
      it 'should call the block and set the images' do
        notification = Notification.new(:growl) do
          show_images :failure => image('fuuu/failure.png')
        end
        
        notification.failure_image.should == image('fuuu/failure.png')
      end
    end
    
    describe '#change_dir_images' do
      it 'should return the simpsons folder' do
        growl.default_dir_images.should == image('simpson')
      end
      
      it 'should pass a symbol and return a folder inside infinity test images folder' do
        growl.change_dir_images :fuuu
        growl.default_dir_images.should == image('fuuu')
      end
      
      it 'should pass a string and return a users folders in any directory of user computer' do
        growl.change_dir_images "/Users/tomas/my_images"
        growl.default_dir_images.should == "/Users/tomas/my_images"
      end
    end
    
    describe '#show_images' do
      context 'on default images' do

        it { growl.sucess_image.should == image('simpson/sucess.jpg') }

        it { growl.pending_image.should == image('simpson/pending.jpg') }

        it { growl.failure_image.should == image('simpson/failure.gif') }
      end
      
      context 'on setting my own image' do

        it "should be possible to customize success image" do
          growl.show_images :sucess => image('other.png')
          growl.sucess_image.should == image('other.png')
        end

        it "should be possible to customize failure image" do
          growl.show_images :failure => image('failure_picture.png')
          growl.failure_image.should == image('failure_picture.png')
        end

        it "should be possible to customize failure image" do
          growl.show_images :pending => image('pending_picture.png')
          growl.pending_image.should == image('pending_picture.png')
        end
        
        it 'pass one only option should not set to nil other options' do
          growl.show_images :pending => image('fuuu/pending.png')
          growl.sucess_image.should == image('simpson/sucess.jpg')
          growl.failure_image.should == image('simpson/failure.gif')
        end
        
      end
      
      context 'setting the directory of images or modes' do

        it "should possible to change the dir of images" do
          growl.show_images :mode => :street_fighter
          growl.pending_image.should == image('street_fighter/pending.gif')
        end

        it "should possible to change the dir of the images" do
          growl.show_images :mode => :toy_story
          growl.sucess_image.should == image('toy_story/sucess.png')
        end

        it "should possible to change the dir of the images" do
          growl.show_images :mode => :fuuu
          growl.sucess_image.should == image('fuuu/sucess.png')
          growl.pending_image.should == image('fuuu/pending.png')
          growl.failure_image.should == image('fuuu/failure.png')
        end

        it "should possible to change the dir of the images" do
          growl.show_images :mode => custom_image_dir
          growl.sucess_image.should == custom_image('images/sucess.png')
        end
        
      end
      
    end
  end
end