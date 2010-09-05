require 'rubygems'

begin
  print Gem.bin_path('rspec', 'spec') # Rspec 1.3.0
rescue
  print Gem.bin_path('rspec-core', 'rspec') # Rspec 2.0.beta
rescue
  print("Appears that you don't have Rspec (1.3.0 or 2.0.beta) installed. Run with: \n gem install rspec  or gem install rspec --pre")
end