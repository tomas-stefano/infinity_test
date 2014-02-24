require 'spec_helper'

module InfinityTest
  module Framework
    describe Base do
      subject(:base) { Base.new(continuous_test_server) }
      let(:continuous_test_server) { double(extension: :rb) }

      describe '#run_all' do
        it 'call run strategy to continuous test server' do
          expect(continuous_test_server).to receive(:run_strategy)
          base.run_all
        end
      end

      describe '#run_test' do
        let(:test_framework) { double(test_dir: 'test') }

        before do
          expect(base).to receive(:test_framework).and_return(test_framework)
        end

        context 'find a file' do
          it 'call run strategy to continuous test server' do
            expect(base.hike).to receive(:find).with('framework/base_test.rb').and_return('framework/base_test.rb')
            expect(continuous_test_server).to receive(:rerun_strategy).with('framework/base_test.rb')
            base.run_test(double(path: 'framework/base'))
          end

          it 'use the extension name from core base' do
            expect(base).to receive(:extension).and_return('py')
            expect(base.hike).to receive(:find).with('framework/base_test.py').and_return('framework/base_test.py')
            expect(continuous_test_server).to receive(:rerun_strategy).with('framework/base_test.py')
            base.run_test(double(path: 'framework/base'))
          end
        end

        context 'when do not find any files' do
          it 'do not call rerun strategy' do
            expect(base.hike).to receive(:find).with('test_framework/rspec_test.rb').and_return(nil)
            expect(continuous_test_server).to_not receive(:rerun_strategy)
            base.run_test(double(path: 'test_framework/rspec'))
          end
        end
      end

      describe '#run_file' do
        it 'rerun strategy passing the changed file path' do
          expect(continuous_test_server).to receive(:rerun_strategy).with('base_spec.rb')
          base.run_file(double(name: 'base_spec.rb', path: 'base_spec'))
        end
      end
    end
  end
end