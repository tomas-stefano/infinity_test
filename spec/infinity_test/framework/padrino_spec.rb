require 'spec_helper'

module InfinityTest
  module Framework
    describe Padrino do
      subject { Padrino.new(Core::Base) }
      describe "#heuristics" do
        it "should add heuristics" do
          expect { subject.heuristics }.to_not raise_exception
        end
      end

      describe ".run?" do
        it "should return true if find the config/apps.rb" do
          mock(File).exist?(File.expand_path('./config/apps.rb')) { true }
          Padrino.should be_run
        end

        it "should return false if don't find the config/apps.rb" do
          mock(File).exist?(File.expand_path('./config/apps.rb')) { false }
          Padrino.should_not be_run
        end
      end
    end
  end
end