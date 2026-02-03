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

        context "when rubies are specified" do
          before do
            allow(Core::Base).to receive(:rubies).and_return(['2.7.0', '3.0.0'])
          end

          it "returns true if the user has rbenv installed" do
            expect(File).to receive(:exist?).with(rbenv_dir).and_return(true)
            expect(Rbenv).to be_run
          end

          it "returns false if the user does not have rbenv installed" do
            expect(File).to receive(:exist?).with(rbenv_dir).and_return(false)
            expect(Rbenv).not_to be_run
          end
        end

        context "when no rubies are specified" do
          before do
            allow(Core::Base).to receive(:rubies).and_return([])
          end

          it "returns false even if rbenv is installed" do
            expect(Rbenv).not_to be_run
          end
        end
      end

      describe '#run!' do
        before do
          allow(Core::Base).to receive(:rubies).and_return(['2.7.0', '3.0.0'])
        end

        context 'with bundler' do
          before do
            allow(Core::Base).to receive(:using_bundler?).and_return(true)
            allow(File).to receive(:exist?).with('Gemfile').and_return(true)
          end

          it 'returns the command for multiple ruby versions with bundle exec' do
            expect(subject.run!).to eq 'RBENV_VERSION=2.7.0 bundle exec rspec spec && RBENV_VERSION=3.0.0 bundle exec rspec spec'
          end
        end

        context 'without bundler' do
          before do
            allow(Core::Base).to receive(:using_bundler?).and_return(false)
          end

          it 'returns the command for multiple ruby versions without bundle exec' do
            expect(subject.run!).to eq 'RBENV_VERSION=2.7.0 rspec spec && RBENV_VERSION=3.0.0 rspec spec'
          end
        end
      end
    end
  end
end
