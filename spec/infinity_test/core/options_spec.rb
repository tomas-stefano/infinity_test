require "spec_helper"

module InfinityTest
  describe Options do
    describe "#parse!" do
      describe "#strategy" do
        it "should parse the --ruby options with rvm" do
          expect(parse('--ruby', 'rvm').strategy).to be :rvm
        end

        it "should parse the --ruby options with rbenv" do
          expect(parse('--ruby', 'rbenv').strategy).to be :rbenv
        end
      end

      describe "#rubies" do
        it "should pass the ruby versions" do
          expect(parse('--rubies=ree,jruby').rubies).to eql %w(ree jruby)
        end

        it "should have empty rubies when pass rubies= without versions" do
          expect(parse('--rubies=').rubies).to eql []
        end

        it "should be nil when don't pass the rubies option" do
          expect(parse.rubies).to be_nil
        end
      end

      describe "#infinity_and_beyond" do
        it "should return false when setting --no-infinity-and-beyond" do
          expect(parse('--no-infinity-and-beyond').infinity_and_beyond).to equal false
          expect(parse('-n').infinity_and_beyond).to equal false
        end

        it "should return nil when not setting the --no-infinity-and-beyond" do
          expect(parse.infinity_and_beyond).to be_nil
        end
      end

      describe "#specific_options" do
        it "should parse the options" do
          expect(parse('--options=-J-Ilib-Itest').specific_options).to eql '-J -Ilib -Itest'
        end
      end

      describe "#test_framework" do
        it "should parse the test framework as rspec" do
          expect(parse('--test', 'rspec').test_framework).to be :rspec
        end

        it "should parse the test framework as bacon" do
          expect(parse('--test', 'bacon').test_framework).to be :bacon
        end

        it "should parse the test framework as test_unit" do
          expect(parse('--test', 'test_unit').test_framework).to be :test_unit
        end

        it "should parse the test framework as other" do
          expect(parse('--test', 'other').test_framework).to be :other
        end
      end

      describe "#framework" do
        it "should parse the app framework as rails" do
          expect(parse('--framework', 'rails').framework).to be :rails
        end

        it "should parse the app framework as rubygems" do
          expect(parse('--framework', 'rubygems').framework).to be :rubygems
        end

        it "should parse the app framework as other" do
          expect(parse('--framework', 'other').framework).to be :other
        end
      end

      describe "#verbose?" do
        it "should return nil when dont pass nothing" do
          expect(parse.verbose?).to be_nil
        end

        it "should not be verbose whe pass the option --no-verbose" do
          expect(parse('--no-verbose')).not_to be_verbose
        end
      end

      describe "#bundler?" do
        it "should not use bundler when passing this option" do
          expect(parse('--no-bundler')).not_to be_bundler
        end

        it "should return nil when dont pass nothing" do
          expect(parse.bundler?).to be_nil
        end
      end
    end

    def parse(*args)
      InfinityTest::Options.new(args.flatten).parse!
    end
  end
end