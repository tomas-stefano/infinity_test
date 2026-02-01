require 'spec_helper'

module InfinityTest
  module Framework
    describe Rails do
      let(:observer) { double('Observer') }
      let(:test_framework) { double('TestFramework') }
      let(:continuous_test_server) { double('ContinuousTestServer', observer: observer, test_framework: test_framework) }
      subject { Rails.new(continuous_test_server) }

      describe "#heuristics" do
        it "adds heuristics" do
          # 6 watch_dir calls: models, controllers, helpers, mailers, jobs, lib, test_dir
          expect(observer).to receive(:watch_dir).exactly(7)
          # 1 watch call for test_helper_file
          expect(observer).to receive(:watch)
          expect(test_framework).to receive(:test_helper_file)
          expect(test_framework).to receive(:test_dir)
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
