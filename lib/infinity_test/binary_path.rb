module InfinityTest
  module BinaryPath
     
    def rspec_path
      begin
        grab_rspec_path
      rescue Exception,Gem::LoadError,Gem::GemNotFoundException
        $stdout.puts("\nAppears that you don't have Rspec (1.3.0 or 2.0.beta) installed. Run with: \n gem install rspec  or gem install rspec --pre")
        $stdout.puts
        exit
      end
    end
    
    def grab_rspec_path
      begin
        Gem.bin_path('rspec-core', 'rspec') # Rspec 2.0.0.beta        
      rescue Exception,Gem::LoadError,Gem::GemNotFoundException
        Gem.bin_path('rspec', 'spec') # Rspec 1.3.0
      end
    end
      
  end
end