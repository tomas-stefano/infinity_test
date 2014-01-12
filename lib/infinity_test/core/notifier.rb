module InfinityTest
  module Core
    class Notifier
      include ::Notifiers

      def initialize(strategy_result, options)
        @server          = options.fetch(:server)
        @strategy_result = strategy_result
      end

      def notify
        # send(@notify_library).message(@message).image(@image)
      end

      # parse_results :examples => /(\d+) example/, :failures => /(\d+) failure/, :pending => /(\d+) pending/

      # # Send the message,image and the actual ruby version to show in the notification system
      #       #
      #       def notify!(options)
      #         if notification_framework
      #           message = parse_results(options[:results])
      #           title = options[:ruby_version]
      #           send(notification_framework).title(title).message(message).image(image_to_show).notify!
      #         else
      #           # skip(do nothing) when not have notification framework
      #         end
      #       end
      #
      #       # Parse the results for each command to the test framework
      #       #
      #       # app.parse_results(['.....','108 examples']) # => '108 examples'
      #       #
      #       def parse_results(results)
      #         test_framework.parse_results(results)
      #       end
      #
      #       # If the test pass, show the sucess image
      #       # If is some pending test, show the pending image
      #       # If the test fails, show the failure image
      #       #
      #       def image_to_show
      #         if test_framework.failure?
      #           failure_image
      #         elsif test_framework.pending?
      #           pending_image
      #         else
      #           sucess_image
      #         end
      #       end
      #
      #       def sucess?
      #         return false if failure? or pending?
      #         true
      #       end
      #
      #       def failure?
      #         @failures > 0
      #       end
      #
      #       def pending?
      #         @pending > 0 and not failure?
      #       end
      #
      #       # Return the message of the tests
      #       #
      #       # test_message('0 examples, 0 failures', { :example => /(\d) example/}) # => '0 examples, 0 failures'
      #       # test_message('....\n4 examples, 0 failures', { :examples => /(\d) examples/}) # => '4 examples, 0 failures'
      #       #
      #       def test_message(output, patterns)
      #         lines = output.split("\n")
      #         final_result = []
      #         patterns.each do |key, pattern|
      #           final_result << lines.select { |line| line =~ pattern }
      #         end
      #         final_result.flatten.last
      #       end
      #
    end
  end
end