require 'spec_helper'

module InfinityTest
  describe BinaryPath do
    include BinaryPath
    
    describe "#bin_path" do
      
      it "should rescue the error when raise a Gem::Exception" do
        bin_path('rspec', 'spec')
        Gem.should_receive(:bin_path).with('rspec', 'spec').and_raise(Gem::Exception)
        $stdout.should_receive(:puts)
        bin_path('rspec', 'spec')
      end
      
      it "should rescue Gem::GemNotFoundException" do
        Gem.should_receive(:bin_path).with('rspec', 'spec').and_raise(Gem::GemNotFoundException)
        $stdout.should_receive(:puts)
        bin_path('rspec', 'spec')
      end

      it "should puts a message when raise a Gem exception" do
        Gem.should_receive(:bin_path).with('rspec', 'spec').once.and_raise(Gem::Exception)
        $stdout.should_receive(:puts).with("Appears that you don't have Rspec installed. Run with: \n gem install rspec")
        lambda { bin_path('rspec', 'spec') }.should_not raise_exception
      end

      it "should grab the bin_path for rspec and return a path" do
        Gem.should_receive(:bin_path).with('rspec', 'spec').and_return('/home/tomas/.rvm/1.8.7/gems/rspec/bin')
        bin_path('rspec', 'spec').should eql '/home/tomas/.rvm/1.8.7/gems/rspec/bin'
      end

      it "should grab the rspec bin path and return in string" do
        Gem.should_receive(:bin_path).with('rspec', 'spec').and_return('/Users/tomas/.rvm/1.8.7/gems/rspec/bin')
        bin_path('rspec', 'spec').should eql '/Users/tomas/.rvm/1.8.7/gems/rspec/bin'
      end
      
    end

  end
end
