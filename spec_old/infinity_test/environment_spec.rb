require 'spec_helper'

module InfinityTest
  describe Environment do
    include Environment
    describe '#environments' do
      it "should raise a exception if not passed a block" do
        expect { environments }.should raise_exception
      end
    end

  end
end
