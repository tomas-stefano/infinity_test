require "spec_helper"

module InfinityTest
  describe Options do
    describe "#parse!" do
      describe "#strategy" do
        it "parses the --ruby options with rvm" do
          expect(parse('--ruby', 'rvm').strategy).to be :rvm
        end

        it "parses the --ruby options with rbenv" do
          expect(parse('--ruby', 'rbenv').strategy).to be :rbenv
        end
      end

      describe "#rubies" do
        it "passes the ruby versions" do
          expect(parse('--rubies=ree,jruby').rubies).to eql %w(ree jruby)
        end

        it "has empty rubies when pass rubies= without versions" do
          expect(parse('--rubies=').rubies).to eql []
        end

        it "is nil when rubies option is not passed" do
          expect(parse.rubies).to be_nil
        end
      end

      describe "#infinity_and_beyond" do
        it "returns false when setting --no-infinity-and-beyond" do
          expect(parse('--no-infinity-and-beyond').infinity_and_beyond).to equal false
          expect(parse('-n').infinity_and_beyond).to equal false
        end

        it "returns nil when not setting the --no-infinity-and-beyond" do
          expect(parse.infinity_and_beyond).to be_nil
        end
      end

      describe "#specific_options" do
        it "parses the options" do
          expect(parse('--options=-J-Ilib-Itest').specific_options).to eql '-J -Ilib -Itest'
        end
      end

      describe "#test_framework" do
        it "parses the test framework as rspec" do
          expect(parse('--test', 'rspec').test_framework).to be :rspec
        end

        it "parses the test framework as test_unit" do
          expect(parse('--test', 'test_unit').test_framework).to be :test_unit
        end

        it "parses the test framework as other" do
          expect(parse('--test', 'other').test_framework).to be :other
        end
      end

      describe "#framework" do
        it "parses the app framework as rails" do
          expect(parse('--framework', 'rails').framework).to be :rails
        end

        it "parses the app framework as rubygems" do
          expect(parse('--framework', 'rubygems').framework).to be :rubygems
        end

        it "parses the app framework as other" do
          expect(parse('--framework', 'other').framework).to be :other
        end
      end

      describe "#verbose?" do
        it "returns nil when nothing is passed" do
          expect(parse.verbose?).to be_nil
        end

        it "is not verbose when passing the option --no-verbose" do
          expect(parse('--no-verbose')).not_to be_verbose
        end
      end

      describe "#bundler?" do
        it "does not use bundler when passing this option" do
          expect(parse('--no-bundler')).not_to be_bundler
        end

        it "returns nil when nothing is passed" do
          expect(parse.bundler?).to be_nil
        end
      end

      describe "#notifications" do
        it "parses the notifications library as auto_discover" do
          expect(parse('--notifications', 'auto_discover').notifications).to be :auto_discover
        end

        it "parses the notifications library as osascript" do
          expect(parse('--notifications', 'osascript').notifications).to be :osascript
        end

        it "parses the notifications library as terminal_notifier" do
          expect(parse('--notifications', 'terminal_notifier').notifications).to be :terminal_notifier
        end

        it "returns nil when nothing is passed" do
          expect(parse.notifications).to be_nil
        end
      end

      describe "#mode" do
        it "parses the image mode as simpson" do
          expect(parse('--mode', 'simpson').mode).to be :simpson
        end

        it "parses the image mode as faces" do
          expect(parse('--mode', 'faces').mode).to be :faces
        end

        it "parses the image mode as rails" do
          expect(parse('--mode', 'rails').mode).to be :rails
        end

        it "returns nil when nothing is passed" do
          expect(parse.mode).to be_nil
        end
      end

      describe "#just_watch" do
        it "returns true when setting --just-watch" do
          expect(parse('--just-watch').just_watch).to eq true
        end

        it "returns true when setting -j" do
          expect(parse('-j').just_watch).to eq true
        end

        it "returns nil when nothing is passed" do
          expect(parse.just_watch).to be_nil
        end
      end

      describe "#focus" do
        it "parses --focus with file path" do
          expect(parse('--focus', 'spec/models/user_spec.rb').focus).to eq 'spec/models/user_spec.rb'
        end

        it "parses -f with file path" do
          expect(parse('-f', 'spec/models/user_spec.rb').focus).to eq 'spec/models/user_spec.rb'
        end

        it "parses --focus failures as symbol" do
          expect(parse('--focus', 'failures').focus).to eq :failures
        end

        it "returns nil when nothing is passed" do
          expect(parse.focus).to be_nil
        end
      end
    end

    def parse(*args)
      InfinityTest::Options.new(args.flatten).parse!
    end
  end
end
