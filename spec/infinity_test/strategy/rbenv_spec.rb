require "spec_helper"

module InfinityTest
  module Strategy
    describe Rbenv do
      let(:base) { BaseFixture.new(test_framework: :rspec) }
      let(:continuous_test_server) { Core::ContinuousTestServer.new(base) }
      subject { Rbenv.new(continuous_test_server) }

      it_should_behave_like 'a infinity test strategy'

      describe ".run?" do
        let(:rbenv_dir) { File.expand_path('~/.rbenv') }

        it "returns true if the user has rbenv installed" do
          expect(File).to receive(:exist?).with(rbenv_dir).and_return(true)
          expect(Rbenv).to be_run
        end

        it "returns false if the user does not have rbenv installed" do
          expect(File).to receive(:exist?).with(rbenv_dir).and_return(false)
          expect(Rbenv).not_to be_run
        end
      end

      describe '#run!' do
        before do
          allow(Core::Base).to receive(:rubies).and_return(['2.7.0', '3.0.0'])
        end

        it 'returns the command for multiple ruby versions' do
          expect(subject.run!).to eq 'RBENV_VERSION=2.7.0 ruby -S rspec spec && RBENV_VERSION=3.0.0 ruby -S rspec spec'
        end
      end
    end
  end
end
