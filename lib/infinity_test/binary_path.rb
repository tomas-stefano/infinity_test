module InfinityTest
  module BinaryPath
    
    def bin_path(gem_name, executable)
      begin
        Gem.bin_path(gem_name, executable)
      rescue Exception => message
        $stdout.puts("Appears that you don't have #{gem_name.capitalize} installed. Run with: \n gem install #{gem_name}")
      end
    end
    
  end
end