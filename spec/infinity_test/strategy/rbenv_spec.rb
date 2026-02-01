require "spec_helper"

module InfinityTest
  module Strategy
    describe Rbenv do
      subject { Rbenv.new(Core::Base) }
      it_should_behave_like 'a infinity test strategy'

      describe ".run?" do
        let(:rbenv_dir) { File.expand_path('~/.rbenv') }
        it "returns true if the user has rbenv installed" do
          expect(File).to receive(:exist?).with(rbenv_dir).and_return(true)
          Rbenv.run?
        end

        it "returns false if the user does not have rbenv installed" do
          expect(File).to receive(:exist?).with(rbenv_dir).and_return(false)
          Rbenv.run?
        end
      end
    end
  end
end
