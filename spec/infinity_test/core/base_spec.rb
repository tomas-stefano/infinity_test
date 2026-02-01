require "spec_helper"

module InfinityTest
  describe Base do
    describe ".setup" do
      it "should yield self" do
        Base.setup do |config|
          expect(config).to be InfinityTest::Base
        end
      end
    end

    describe ".using_bundler?" do
      it "should return the same bundler accessor" do
        expect(Base.using_bundler?).to equal Base.bundler
      end
    end

    describe "#verbose?" do
      it "should return the same verbose accessor" do
        expect(Base.verbose?).to equal Base.verbose
      end
    end

    describe ".observer" do
      it "should have watchr as default observer" do
        expect(Base.observer).to equal :watchr
      end
    end

    describe ".ignore_test_files" do
      it "should not have test files to ignore as default" do
        expect(Base.ignore_test_files).to eql []
      end
    end

    describe "#ignore_test_folders" do
      it "should not ignore test folders as default" do
        expect(Base.ignore_test_folders).to eql []
      end
    end

    describe ".before" do
      before { pending }
      let(:proc) { Proc.new { 'To Infinity and beyond!' } }

      it "should create before callback instance and push to the callback accessor" do
        expect(BeforeCallback).to receive(:new).with(:all, &proc).once.and_return(:foo)
        before_callback = Base.before(:all, &proc)
        expect(before_callback).to be :foo
        expect(Base.callbacks).to be_include before_callback
      end
    end

    describe ".after" do
      before { pending }
      let(:proc) { Proc.new {}}

      it "should create before callback instance and push to the callback accessor" do
        expect(AfterCallback).to receive(:new).with(:each, &proc).once.and_return(:foo)
        after_callback = Base.after(:each, &proc)
        expect(after_callback).to be :foo
        expect(Base.callbacks).to be_include after_callback
      end
    end

    describe ".notifications" do
      it "should set the notification class accessor" do
        silence_stream(STDOUT) do
          Base.notifications(:growl)
          expect(Base.notifications).to be :growl
        end
      end

      it "should set the images" do
        silence_stream(STDOUT) do
          Base.notifications(:growl) do
            show_images :success_image => 'foo', :failure_image => 'bar', :pending_image => 'baz'
          end
        end
        expect(Base.success_image).to eql 'foo'
        expect(Base.failure_image).to eql 'bar'
        expect(Base.pending_image).to eql 'baz'
        Base.success_image = nil
        Base.failure_image = nil
        Base.pending_image = nil
      end

      it "should set the mode" do
        silence_stream(STDOUT) do
          Base.notifications(:growl) do
            show_images :mode => :mortal_kombat
          end
        end
        expect(Base.mode).to be :mortal_kombat
      end
    end

    describe ".use" do
      before do
        @old_rubies = Base.rubies
        @old_specific_options = Base.specific_options
        @test_framework = Base.test_framework
        @framework = Base.framework
        @verbose = Base.verbose
        @gemset  = Base.gemset
      end

      after do
        Base.rubies = @old_rubies
        Base.specific_options = @old_specific_options
        Base.test_framework = @test_framework
        Base.framework = @framework
        Base.verbose = @verbose
        Base.gemset = @gemset
      end

      it "should set the rubies" do
        silence_stream(STDOUT) do
          Base.use :rubies => %w(foo bar)
        end
        expect(Base.rubies).to eql %w(foo bar)
      end

      it "should set the specific options" do
        silence_stream(STDOUT) do
          Base.use :specific_options => '-J -Ilib -Itest'
        end
        expect(Base.specific_options).to eql '-J -Ilib -Itest'
      end

      it "should set the test framework" do
        silence_stream(STDOUT) do
          Base.use :test_framework => :rspec
        end
        expect(Base.test_framework).to be :rspec
      end

      it "should set the app framework" do
        silence_stream(STDOUT) do
          Base.use :app_framework => :rails
        end
        expect(Base.framework).to be :rails
      end

      it "should set the verbose mode" do
        silence_stream(STDOUT) do
          Base.use :verbose => false
        end
        expect(Base.verbose).to equal false # I choose to don't use should be_false
      end

      it "should set the gemset" do
        silence_stream(STDOUT) do
          Base.use :gemset => 'infinity_test'
        end
        expect(Base.gemset).to eql 'infinity_test'
      end
    end

    describe ".heuristics" do
      it "should accept a block" do
        expect { Base.heuristics {} }.to_not raise_exception
      end
    end

    describe ".replace_patterns" do
      it "should accept a block" do
        expect { Base.replace_patterns {} }.to_not raise_exception
      end
    end

    describe ".merge!" do
      let(:options) { Object.new }
      let(:configuration_merge) { Object.new }

      it "should call merge on the configuration merge object" do
        expect(ConfigurationMerge).to receive(:new).with(Core::Base, options).and_return(configuration_merge)
        expect(configuration_merge).to receive(:merge!)
        Core::Base.merge!(options)
      end
    end

    describe ".clear" do
      it "should call clear_terminal method" do
        silence_stream(STDOUT) do
          expect(Base).to receive(:clear_terminal).and_return(true)
          Base.clear(:terminal)
        end
      end
    end

    describe ".clear_terminal" do
      it "should call system clear" do
        silence_stream(STDOUT) do
          expect(Base).to receive(:system).with('clear').and_return(true)
          Base.clear_terminal
        end
      end
    end
  end
end