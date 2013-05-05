require "spec_helper"

module InfinityTest
  module Strategy
    describe Rbenv do
      subject { Rbenv.new(Core::Base) }
      it_should_behave_like 'a infinity test strategy'

      describe ".run?" do
        let(:rbenv_dir) { File.expand_path('~/.rbenv') }
        it "should return true if the user had the rbenv installed" do
          File.should_receive(:exist?).with(rbenv_dir).and_return(true)
          Rbenv.run?
        end

        it "should return false if the user don't had the rbenv installed" do
          File.should_receive(:exist?).with(rbenv_dir).and_return(false)
          Rbenv.run?
        end
      end
    end
  end
end
