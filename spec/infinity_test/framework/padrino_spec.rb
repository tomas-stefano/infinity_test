require 'spec_helper'

module InfinityTest
  module Framework
    describe Padrino do
      subject { Padrino.new(Core::Base) }
      describe "#heuristics" do
        it "adds heuristics" do
          expect { subject.heuristics }.to_not raise_exception
        end
      end

      describe ".run?" do
        it "returns true if config/apps.rb exists" do
          expect(File).to receive(:exist?).with(File.expand_path('./config/apps.rb')).and_return(true)
          expect(Padrino).to be_run
        end

        it "returns false if config/apps.rb does not exist" do
          expect(File).to receive(:exist?).with(File.expand_path('./config/apps.rb')).and_return(false)
          expect(Padrino).not_to be_run
        end
      end
    end
  end
end
