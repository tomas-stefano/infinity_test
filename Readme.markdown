# Infinity Test

Infinity Test is a continuous testing library and a flexible alternative to
Autotest, using the awesome Watchr library with RSpec, Test::Unit, Bacon and
with RVM functionality, giving the possibility to test with all Ruby versions
that you have in your RVM configuration.

## To Infinity and Beyond!

<div style="padding:2px; border:1px solid silver; float:right; margin:0 0 1em 2em; background:white">
  <img src="https://github.com/tomas-stefano/infinity_test/raw/master/buzz_images/to_infinity_and_beyond.png" alt="Infinity Test" />
  <p style="text-align:center">Photo taken from <a href="http://www.mixed-metaphor.org/fan/buzz/" title="buzz-light-year">this site</a></p>
</div>

## Install

    gem install infinity_test

## Running Tests with the current Ruby

With RSpec:

    infinity_test --rspec

With Test::Unit:

    infinity_test --test-unit

With Bacon:

    infinity_test --bacon

## Running Tests with multiple Rubies

With RSpec:

    infinity_test --rspec --rubies=1.8.7,jruby,1.9.2,ree

Or with Test::Unit:

    infinity_test --test-unit --rubies=1.8.7,jruby,ree,1.9.2

Or with bacon:

    infinity_test --bacon --rubies=1.8.7,ree,1.9.2

You can pass arguments to specific versions of Ruby with a '+' character:

    infinity_test --rspec --rubies=jruby+"J-cp bar/whisky-in-the.jar:."

**Now you are ready to run your test suite against all Ruby versions with
Autotest-like behavior.**

## Running Tests with Rails

    infinity_test --rails

## Configuration file

### Simple Domain Specific Language for Infinity Test file

If you'd rather not constantly specify which versions of Ruby to use, or the
testing framework to use, or which notifications you want to receive, you can
specify those options one time in an `.infinity_test` file.

You can create this file in your `$HOME` directory to be used globally across
all projects, or you can specify the options per-project in the project's root
folder:

    # ~/.infinity_test or .infinity_test

    infinity_test do
      notifications :growl do
        show_images :mode => :mario_bros
      end

      use :rubies => %w(1.9.1 jruby 1.9.2 ree), :test_framework => :rspec

      use :specific_options => {'jruby' => 'J-cp bar/whisky-in-the.jar:.'}

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

If you want to customize and understand the .infinity_test file, [read this
page](http://github.com/tomas-stefano/infinity_test/wiki/Customize-Infinity-Test).

# Color in Test::Unit

* Use the gem [minitest-colorize](https://github.com/sobrinho/minitest-colorize)

# Color in RSpec

### Put this in your .rspec file:

In RSpec 2.2.0:

    --color
    --tty

In RSpec 2.1.0:

    --color
    --autotest

In RSpec 1.3, use the **spec.opts** file:

    --color
    --autospec

**Note: These options will be the defaults in a future version of Infinity Test**

### Future

* Add support for focus files (run failed results and then run all tests if those pass, etc.)

## You Like it the Idea?

So make a fork and start contributing =].

## You have a Feature request or Fix?

Contact me on GitHub, or Twitter ([@tomas_stefano](https://twitter.com/tomas_stefano)) and let's talk! =]

# Acknowledgments

* Thanks to Mynyml and Watchr library.
* Thanks to Waynee Seguin and the RVM.
