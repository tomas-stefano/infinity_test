
begin
  print Gem.bin_path('cucumber', 'cucumber')
rescue
  print("Appears that you don't have Cucumber installed. Run with: \n gem install cucumber")
end