require "spec_helper"

module InfinityTest
  module Strategy
    describe Rvm do
      let(:base) { BaseFixture.new(test_framework: :rspec) }
      let(:continuous_test_server) { Core::ContinuousTestServer.new(base) }
      subject { Rvm.new(continuous_test_server) }

      it_should_behave_like 'a infinity test strategy'

      describe ".run?" do
        it "returns true if the user has RVM installed in users home" do
          expect(Rvm).to receive(:installed_users_home?).and_return(true)
          expect(Rvm).to be_run
        end

        it "returns true if the user has RVM installed system wide" do
          expect(Rvm).to receive(:installed_users_home?).and_return(false)
          expect(Rvm).to receive(:installed_system_wide?).and_return(true)
          expect(Rvm).to be_run
        end

        it "returns false if the user does not have RVM installed" do
          expect(Rvm).to receive(:installed_users_home?).and_return(false)
          expect(Rvm).to receive(:installed_system_wide?).and_return(false)
          expect(Rvm).not_to be_run
        end
      end

      describe '#run!' do
        before do
          allow(Core::Base).to receive(:rubies).and_return(['2.7.0', '3.0.0'])
          allow(Core::Base).to receive(:gemset).and_return(nil)
        end

        it 'returns the command for multiple ruby versions' do
          expect(subject.run!).to eq 'rvm 2.7.0 do ruby -S rspec spec && rvm 3.0.0 do ruby -S rspec spec'
        end

        context 'with gemset' do
          before do
            allow(Core::Base).to receive(:gemset).and_return('infinity_test')
          end

          it 'includes gemset in the command' do
            expect(subject.run!).to eq 'rvm 2.7.0@infinity_test do ruby -S rspec spec && rvm 3.0.0@infinity_test do ruby -S rspec spec'
          end
        end
      end
    end
  end
end
