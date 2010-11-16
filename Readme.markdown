# Infinity Test


Infinity Test is a continuous testing library and a flexible alternative to Autotest,
using the awesome Watchr library with Rspec, Test::Unit, Bacon and with RVM funcionality,
giving the possibility to test with all <b>Rubies</b> that you have in your RVM configuration.

## To Infinity and Beyond!

<div style="padding:2px; border:1px solid silver; float:right; margin:0 0 1em 2em; background:white">
  <img src="http://github.com/tomas-stefano/infinity_test/raw/master/buzz_images/to_infinity_and_beyond.png" alt="Infinity Test" />
  <p style="text-align:center"> Photo taken by <a href="http://www.mixed-metaphor.org/fan/buzz/" title="buzz-light-year"> this site </a></p>
</div>

## Install

     gem install infinity_test

## Running Tests only in one ruby

With Rspec:

    infinity_test --rspec

With Test::Unit:

    infinity_test --test-unit

With Bacon:

    infinity_test --bacon

## Running Tests with many Rubies

With Rspec:

    infinity_test --rspec --rubies=1.8.7,jruby,1.9.2,ree

Or with Test::Unit:

    infinity_test --test-unit --rubies=1.8.7,jruby,ree,1.9.2

Or with bacon:

    infinity_test --bacon --rubies=1.8.7,ree,1.9.2

<b>And you are ready to Test with all ruby versions your Rspec or Test::Unit Suite with Autotest-like Behavior.</b>

## Running Tests with Rails (only in master branch!)

With Rails:

    infinity_test --rails

## Configuration file

### Simple Domain Specific Language for Infinity Test file

If you don't set all the time the rubies that you want, test framework that you want, notifications that you want,
you can write some code that infinity_test understand.

So create the global file or project file called:

      ~/.infinity_test or .infinity_test

      infinity_test do

        notifications :growl do
          show_images :mode => :mario_bros
        end

        use :rubies => %w(1.9.1 jruby 1.9.2 ree), :test_framework => :rspec

        before(:each_ruby) do |environment|
          # ...
        end

        after(:each_ruby) do |environment|
          # ...
        end

        before_run do
          clear :terminal
        end

        after_run do
          # ...
        end

        heuristics('my_pattern') do |file|
          # ...
        end

        replace_patterns do |application|
          # ...
        end

      end

## Customize the .infinity_test file

#### If you want to customize and understand the .infinity_test file, <a href='http://github.com/tomas-stefano/infinity_test/wiki/Customize-Infinity-Test'>Read this Page</a>

# Color in RSpec

### Put this in your <b>.rspec</b> file:

    --color
    --autotest

## You Like it the Idea?

<b>So make a fork and start contributing =].</b>

## You have a Feature request or Fix?

<b>Contact me in Github and let's talk! =] </b>

# Acknowledgments

* Thanks to Mynyml and Watchr library.
* Thanks to Waynee Seguin and the RVM.
