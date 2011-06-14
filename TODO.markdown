Future
======

- Big refactoring
- Fix heuristics for Rails/Test Unit users
- Support Cucumber
- Run with failed tests (Focus mode!!)
- Create a method that installed all the rubies, gemsets and gems with pure ruby. This is a example the so easy to implement this feature:

#
    infinity_test --install-all
    
##### This code will working inside infinity_test source

    rubies.each do |ruby|
      system("rvm install #{ruby}") if ruby_is_not_installed? # JUST only need to create this method ;)
      system("rvm #{ruby}")
	  system("rvm gemset use #{gemset_or_global}") if gemset_not_exist?
	  system("gem install bundler") if bundler_not_installed?
	  system("bundle install")
	end

- Put a method in the configuration file called #ignore like:

Example:

     ignore :folders => %w(), :files => %w()

- Put some methods in the configuration file like: #all_tests_pass?, #all_tests_pass_in_ruby? like:

Example:

	after(:all) do
      if all_tests_pass?
        # do something
      end
               
      if all_tests_pass_in_ruby?('1.8.7') 
        # do something
      end
	end

Bugs
====

- Coloring the output with Test::Unit (maybe using RedGreen)
