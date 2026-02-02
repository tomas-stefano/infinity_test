require 'spec_helper'

module InfinityTest
  module Framework
    describe Rails do
      let(:observer) { double('Observer') }
      let(:test_framework) { double('TestFramework', test_dir: 'spec') }
      let(:continuous_test_server) { double('ContinuousTestServer', observer: observer, test_framework: test_framework) }
      subject { Rails.new(continuous_test_server) }

      describe "#heuristics" do
        it "watches lib, test_dir, and test_helper_file" do
          allow(File).to receive(:directory?).with('app').and_return(false)

          expect(observer).to receive(:watch_dir).with(:lib)
          expect(observer).to receive(:watch_dir).with('spec')
          expect(observer).to receive(:watch)
          expect(test_framework).to receive(:test_helper_file)

          expect { subject.heuristics }.to_not raise_exception
        end

        it "auto-discovers app directories containing ruby files" do
          allow(File).to receive(:directory?).with('app').and_return(true)
          allow(Dir).to receive(:glob).with('app/*').and_return(['app/models', 'app/views', 'app/components'])
          allow(File).to receive(:directory?).with('app/models').and_return(true)
          allow(File).to receive(:directory?).with('app/views').and_return(true)
          allow(File).to receive(:directory?).with('app/components').and_return(true)
          allow(Dir).to receive(:glob).with('app/models/**/*.rb').and_return(['app/models/user.rb'])
          allow(Dir).to receive(:glob).with('app/views/**/*.rb').and_return([])
          allow(Dir).to receive(:glob).with('app/components/**/*.rb').and_return(['app/components/button.rb'])

          # Should watch models and components (have .rb files), skip views (no .rb files)
          expect(observer).to receive(:watch_dir).with('app/models')
          expect(observer).to receive(:watch_dir).with('app/components')
          expect(observer).to receive(:watch_dir).with(:lib)
          expect(observer).to receive(:watch_dir).with('spec')
          expect(observer).to receive(:watch)
          expect(test_framework).to receive(:test_helper_file)

          expect { subject.heuristics }.to_not raise_exception
        end
      end

      describe ".run?" do
        it "returns true if config/environment.rb exists" do
          expect(File).to receive(:exist?).with(File.expand_path('./config/environment.rb')).and_return(true)
          expect(Rails).to be_run
        end

        it "returns false if config/environment.rb does not exist" do
          expect(File).to receive(:exist?).with(File.expand_path('./config/environment.rb')).and_return(false)
          expect(Rails).not_to be_run
        end
      end
    end
  end
end
