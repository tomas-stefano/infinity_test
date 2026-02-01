## Todo

Infinity test is a gem that watch files changes and run tests.

That also can run with different ruby versions all test suite or only that file change (using rvm or
rbenv), ruby default just run the test on the current ruby version.

## What Needs to Be Done

* ~~Make notifications work with Notifiers gem (remove growl and use the autodiscover from notifiers gem).~~ DONE
* ~~Change .infinity_test to INFINITY_TEST~~ DONE
* ~~Make Test::Unit to work (the infinity test to check test folder).~~ DONE
* ~~Make RSpec work~~ DONE
* ~~Finish RubyDefault strategy~~ DONE
* ~~Finish RVM (running different versions - the user need to specify)~~ DONE
* ~~Finish RbEnv (running different versions - the user need to specify)~~ DONE
* Make callbacks work in the new structure (loading the infinity test file).
* Finish Gem autodiscover and its changes heuristics.
* Finish Rails autodiscover and its changes heuristics.
* Padrino autodiscover and its changes heuristics.
* Improve auto discover feature priorization subclasses for #run? method.
* Focus feature(fails, pass one file, run entire suite) with --focus (experimented feature)!
* Add post-run hooks to be added to the INFINITY_TEST file that run other things (coverage, code
analysis, etc - see ideas)

* Give some ideas (write to a md file the ideas) about how to integrate the infinity test with AI tools/AI agents or
even Claude code ... so ruby developers can see

* Update HISTORY with all changes since last version.
