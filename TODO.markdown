Rewrite
=======

- The InfinityTest needs rewrite.

## Goals

* Remove the todays implementation.
* Supporting DSL and No DSL(class by a contract).
* Rewrite the entire library.
* RbEnv feature.
* RVM feature.
* Run with normal ruby
* Focus feature (fails, pass one file, run entire suite) with --focus (experimented feature).
* Don't run integration tests. Ignore them when changed.
* Test with spork and other gems spork like.
* Be possible to rewrite the rules in more nicer way, using the Hike gem to find files and paths.
* Magic discovery if is test unit or rspec.
* Be possible to overwrite the entire command to run.
* Put some methods in the configuration file like: #all_tests_pass?, #all_tests_pass_in_ruby?.
* Put a Thor generator.
* Put an option to just run and exit.
* Put a profile feature to handle rubies.
* Need to see the #replace_patterns and #heuristics method in the configuration file.

### Features

* Ruby Implementations and normal ruby. (rvm command, rbenv command or normal ruby)
* Focus Feature
* Ignore files/folders
* Rewrite the rules to watch files and run the specs
* Generator
* Todays Setup.
