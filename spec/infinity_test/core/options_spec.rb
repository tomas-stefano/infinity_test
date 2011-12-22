require "spec_helper"

module InfinityTest
  describe Options do
    describe "#parse!" do
      describe "#strategy" do
        it "should parse the --ruby options with rvm" do
          parse('--ruby', 'rvm').strategy.should be :rvm
        end

        it "should parse the --ruby options with rbenv" do
          parse('--ruby', 'rbenv').strategy.should be :rbenv
        end
      end

      describe "#rubies" do
        it "should pass the ruby versions" do
          parse('--rubies=ree,jruby').rubies.should eql %w(ree jruby)
        end
      end

      describe "#specific_options" do
        it "should parse the options" do
          parse('--options=-J-Ilib-Itest').specific_options.should eql '-J -Ilib -Itest'
        end
      end

      describe "#test_framework" do
        it "should parse the test framework as rspec" do
          parse('--test', 'rspec').test_framework.should be :rspec
        end

        it "should parse the test framework as bacon" do
          parse('--test', 'bacon').test_framework.should be :bacon
        end

        it "should parse the test framework as test_unit" do
          parse('--test', 'test_unit').test_framework.should be :test_unit
        end

        it "should parse the test framework as other" do
          parse('--test', 'other').test_framework.should be :other
        end
      end

      describe "#framework" do
        it "should parse the app framework as rails" do
          parse('--framework', 'rails').framework.should be :rails
        end

        it "should parse the app framework as rubygems" do
          parse('--framework', 'rubygems').framework.should be :rubygems
        end

        it "should parse the app framework as other" do
          parse('--framework', 'other').framework.should be :other
        end
      end

      describe "#verbose?" do
        it "should return nil when dont pass nothing" do
          parse.verbose?.should be_nil
        end

        it "should not be verbose whe pass the option --no-verbose" do
          parse('--no-verbose').should_not be_verbose
        end
      end

      describe "#bundler?" do
        it "should not use bundler when passing this option" do
          parse('--no-bundler').should_not be_bundler
        end

        it "should return nil when dont pass nothing" do
          parse.bundler?.should be_nil
        end
      end
    end

    def parse(*args)
      InfinityTest::Options.new(args.flatten).parse!
    end
  end
end