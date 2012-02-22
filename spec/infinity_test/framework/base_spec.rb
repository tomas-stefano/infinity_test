require 'spec_helper'

module InfinityTest
  module Framework
    describe Base do
      describe ".subclasses" do
        it "should have rvm, rbenv, rubydefault and autodiscover as subclasses" do
          Base.subclasses.should include(Rails, Padrino, Rubygems, AutoDiscover)
        end
      end

      describe ".framework_name" do
        it "should return the framework name demodulized" do
          Rails.framework_name.should be :rails
        end

        it "should return the framework name downcased" do
          Rubygems.framework_name.should be :rubygems
        end

        it "should return with underscore" do
          AutoDiscover.framework_name.should be :auto_discover
        end
      end
    end
  end
end