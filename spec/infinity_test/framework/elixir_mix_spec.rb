require 'spec_helper'

module InfinityTest
  module Framework
    describe ElixirMix do
      let(:observer) { double('Observer') }
      let(:test_framework) { double('TestFramework', test_dir: 'test', test_helper_file: 'test/test_helper.exs') }
      let(:continuous_test_server) { double('ContinuousTestServer', observer: observer, test_framework: test_framework) }
      subject { ElixirMix.new(continuous_test_server) }

      describe "#heuristics" do
        it "adds heuristics for lib, test, and test_helper" do
          expect(observer).to receive(:watch_dir).with(:lib, :ex)
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

      describe ".run?" do
        it "returns true if there is a mix.exs in the user current dir" do
          expect(File).to receive(:exist?).with('mix.exs').and_return(true)
          expect(ElixirMix).to be_run
        end

        it "returns false if there is no mix.exs in the user current dir" do
          expect(File).to receive(:exist?).with('mix.exs').and_return(false)
          expect(ElixirMix).not_to be_run
        end
      end
    end
  end
end
