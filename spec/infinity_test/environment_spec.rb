require 'spec_helper'

module InfinityTest
  describe Environment do
    include Environment
    describe '#environments' do
      it "should raise a exception if not passed a block" do
        expect { environments }.should raise_exception
      end
      
      it "should run in the scope of RVM environment" do
        lambda {
          environments do |environment, ruby_version| 
             environment.should be_instance_of(RVM::Environment)
          end
        }.should_not raise_exception
      end
      
    end
    
  end
end