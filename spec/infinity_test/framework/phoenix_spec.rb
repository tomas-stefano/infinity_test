require 'spec_helper'

module InfinityTest
  module Framework
    describe Phoenix do
      let(:observer) { double('Observer') }
      let(:test_framework) { double('TestFramework', test_dir: 'test', test_helper_file: 'test/test_helper.exs') }
      let(:continuous_test_server) { double('ContinuousTestServer', observer: observer, test_framework: test_framework) }
      subject { Phoenix.new(continuous_test_server) }

      describe "#heuristics" do
        before do
          allow(subject).to receive(:watch_lib_dirs)
        end

        it "adds heuristics for lib dirs, test, and test_helper" do
          expect(subject).to receive(:watch_lib_dirs)
          expect(observer).to receive(:watch_dir).with('test', :exs)
          expect(observer).to receive(:watch).with('test/test_helper.exs')
          expect { subject.heuristics }.to_not raise_exception
        end
      end

      describe "#heuristics!" do
        it "appends .exs extension to hike" do
          hike = double('Hike')
          allow(subject).to receive(:hike).and_return(hike)
          expect(hike).to receive(:append_extension).with('.exs')
          expect(hike).to receive(:append_path).with('test')
          allow(subject).to receive(:heuristics)
          subject.heuristics!
        end
      end

      describe "#watch_lib_dirs" do
        context "when lib directory exists with subdirectories" do
          before do
            allow(File).to receive(:directory?).with('lib').and_return(true)
            allow(Dir).to receive(:glob).with('lib/*').and_return(['lib/my_app', 'lib/my_app_web'])
            allow(File).to receive(:directory?).with('lib/my_app').and_return(true)
            allow(File).to receive(:directory?).with('lib/my_app_web').and_return(true)
            allow(Dir).to receive(:glob).with('lib/my_app/**/*.ex').and_return(['lib/my_app/accounts.ex'])
            allow(Dir).to receive(:glob).with('lib/my_app_web/**/*.ex').and_return(['lib/my_app_web/controllers/page_controller.ex'])
          end

          it "watches all lib subdirectories with .ex files" do
            expect(observer).to receive(:watch_dir).with('lib/my_app', :ex)
            expect(observer).to receive(:watch_dir).with('lib/my_app_web', :ex)
            subject.watch_lib_dirs
          end
        end

        context "when lib directory does not exist" do
          before do
            allow(File).to receive(:directory?).with('lib').and_return(false)
          end

          it "does nothing" do
            expect(observer).not_to receive(:watch_dir)
            subject.watch_lib_dirs
          end
        end
      end

      describe ".run?" do
        it "returns true if mix.exs exists and has lib/*_web directory" do
          expect(File).to receive(:exist?).with('mix.exs').and_return(true)
          expect(Dir).to receive(:glob).with('lib/*_web').and_return(['lib/my_app_web'])
          expect(Phoenix).to be_run
        end

        it "returns false if mix.exs does not exist" do
          expect(File).to receive(:exist?).with('mix.exs').and_return(false)
          expect(Phoenix).not_to be_run
        end

        it "returns false if no lib/*_web directory exists" do
          expect(File).to receive(:exist?).with('mix.exs').and_return(true)
          expect(Dir).to receive(:glob).with('lib/*_web').and_return([])
          expect(Phoenix).not_to be_run
        end
      end
    end
  end
end
