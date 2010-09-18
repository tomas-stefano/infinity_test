# Infinity Test


Infinity Test is a continuous testing library and a flexible alternative to Autotest, 
using Watchr library with Rspec OR Test::Unit with RVM funcionality,
giving the possibility to test with all <b>Rubies</b> that you have in your RVM configuration.

## To Infinity and Beyond!

<div style="padding:2px; border:1px solid silver; float:right; margin:0 0 1em 2em; background:white">
  <img src="http://github.com/tomas-stefano/infinity_test/raw/master/to_infinity_and_beyond.png" alt="Infinity Test" />
  <p style="text-align:center"> Photo taken by <a href="http://www.mixed-metaphor.org/fan/buzz/" title="buzz-light-year"> this site </a></p>
</div>

## Install

*   The Infinity Test gem don't have a version, but <b>is looking for contributors</b>. =]

This gem will be released in September 17.

## Running Tests only in one ruby

With Rspec:

    infinity_test --rspec

With Test::Unit:

	infinity_test --test-unit

## Running Tests with many Rubies

With Rspec:

    infinity_test --rspec --rubies=1.8.7,jruby,1.9.2,ree

Or with Test::Unit:

    infinity_test --test-unit --rubies=1.8.7,jruby,ree,1.9.2

<b>And you are ready to Test with all ruby versions your Rspec or Test::Unit Suite with Autotest-like Behavior.</b>

## Configuration file

### Simple Domain Specific Language for Configuration file

If you don't set all the time the rubies that you want, test framework that you want, notifications that you want,
you can write some code that infinity_test understand.

So create the global file or project file called:

      ~/.infinity_test or .infinity_test

      infinity_test do
      
          notifications :growl do
		    show_images :mode => :mario_bros
          end
          
          use :rubies => %w(1.9.1 jruby 1.9.2 ree), :test_framework => :rspec
          
          before_run do
            clear :terminal
          end
          
          after_run do
            puts 'Finished!'
          end
      
      end

<b>If you want to customize and understand the .infinity_test file, <a href='http://github.com/tomas-stefano/infinity_test/wiki/Customize-Infinity-Test'>read this page</a> </b>

## Tested Rubies

Pass all the entire test suite in the following rubies:

* 1.8.7
* 1.9.1
* 1.9.2
* REE
* JRuby
* Rubinius

## You Like it the Idea?

<b>So make a fork and start contributing =].</b>

## You have a Feature request or Fix?

<b>Contact me in Github and let's talk! =] </b>

## TODO

* Edit the wiki
* Working in focus files and run only the modified file (Strategies for Test::Unit, Rspec and Cucumber)

# Acknowledgments

* Thanks to Mynyml and Watchr library.
* Thanks to Waynee Seguin and the RVM.
