require 'spec_helper'

module InfinityTest
  module Framework
    describe Rails do
      subject { Rails.new(Core::Base) }
      describe "#heuristics" do
        it "should add heuristics" do
          expect { subject.heuristics }.to_not raise_exception
        end
      end

      describe ".run?" do
        it "should return true if exist the config/enviroment.rb file" do
          mock(File).exist?(File.expand_path('./config/environment.rb')) { true }
          Rails.should be_run
        end

        it "should return false if don't exist the config/enviroment.rb file" do
          mock(File).exist?(File.expand_path('./config/environment.rb')) { false }
          Rails.should_not be_run
        end
      end
    end
  end
end