module InfinityTest
  module Notifications
    class Growl
      #
      # output = autotest.results.grep(/\d+\s.*examples?/).
      # last.slice(/(\d+)\s.*examples?,\s(\d+)\s.*failures?(?:,\s(\d+)\s.*pending)?/)
      # 
      #   # if output =~ /[1-9]\sfailures?/ 
      # 
      #   if output =~ /[1-9][0-9]?\sfailure/
      # 
      #     growl "Test Results", "#{output}", "failure.png", 2, "-s"
      # 
      #   elsif output =~ /pending/
      # 
      #     growl "Test Results", "#{output}", "~/Library/autotest/pending.png"
      # 
      #   else
      # 
      #     growl "Test Results", "#{output}", "sucess.png"
      # 
      #   end
      
      # growl(:ruby_version => "Ruby 1.9.2", :message => "0 examples, 0 failures", :name => 'infinity_test')
      
      def self.notify(options)
        system "growlnotify -n infinity_test -m '#{options[:message]}' -t 'Ruby #{options[:tittle]}'"
      end
      
    end
  end
end