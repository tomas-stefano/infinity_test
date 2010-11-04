require 'spec_helper'

module InfinityTest
  module TestLibrary
    describe TestLibrary::Cucumber do
      describe '#search_cucumber' do
        it "should return the path for Cucumber" do
          cucumber = InfinityTest::TestLibrary::Cucumber.new
          cucumber.search_cucumber(current_env).should match /cucumber\z/
        end
      end
    end
  end
end