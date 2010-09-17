module InfinityTest
  module Notifications
    class Growl
      
      # Notification via Growl
      #
      # Growl.new.notify(:ruby_version => "Ruby 1.9.2", :message => "0 examples, 0 failures", :image => 'image.png')
      #
      def notify(options)
        system "growlnotify -n infinity_test -m '#{options[:message]}' -t 'Ruby #{options[:title]}' --image #{options[:image]} -n infinity_test"
      end
      
    end
  end
end