require "spec_helper"

module InfinityTest
  module Strategy
    describe RubyDefault do
      let(:base) { BaseFixture.new }
      let(:continuous_test_server) { Core::ContinuousTestServer.new(base) }
      subject { RubyDefault.new(continuous_test_server) }
      it_should_behave_like 'a infinity test strategy'

      describe ".run?" do
        it "returns true when no ruby versions are passed to run tests" do
          allow(Core::Base).to receive(:rubies).and_return([])
          expect(RubyDefault).to be_run
        end

        it "returns false when some ruby version is passed to run tests" do
          allow(Core::Base).to receive(:rubies).and_return(['ree', 'jruby'])
          expect(RubyDefault).not_to be_run
        end
      end

      describe '#run!' do
        before { base.test_framework = :rspec }

        context 'with bundler' do
          before do
            allow(Core::Base).to receive(:using_bundler?).and_return(true)
            allow(File).to receive(:exist?).with('Gemfile').and_return(true)
          end

          it 'returns the command with bundle exec' do
            expect(subject.run!).to eq 'bundle exec rspec spec'
          end
        end

        context 'without bundler' do
          before do
            allow(Core::Base).to receive(:using_bundler?).and_return(false)
          end

          it 'returns the command without bundle exec' do
            expect(subject.run!).to eq 'rspec spec'
          end
        end
      end
    end
  end
end
