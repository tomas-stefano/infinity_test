## Todo

Potential improvements and features for Infinity Test.

## Next Steps

### High Priority

* Replace Hike gem dependency (last updated 12 years ago) with a simple built-in file finder
* Add support for notification timeout/duration (use alerter for macOS, notify-send -t for Linux)
* Add Minitest as explicit test framework option (currently uses test_unit)

### Features

* Add `--watch-only` option to specify specific directories to watch
* Add `--ignore` CLI option to ignore specific files/patterns
* Support for custom file extensions beyond .rb (e.g., .rake, .erb with embedded Ruby)
* Add `--fail-fast` option to stop on first failure

### Developer Experience

* Add `--dry-run` option to show what command would be executed without running
* Add `--debug` flag for troubleshooting file watching issues
* Improve error messages when test framework is not found
* Add startup banner showing detected configuration (framework, test lib, ruby strategy)

### Integrations

* Add GitHub Actions workflow template for CI
* Add hook system for pre/post test execution scripts
* Support for Docker-based Ruby version testing
* Integration with code coverage tools (SimpleCov reporting)

### Documentation

* Add more examples to wiki for common use cases
* Add troubleshooting guide
* Add migration guide from Guard/Autotest
