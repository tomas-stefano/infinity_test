module InfinityTest
   module Notifications
     class LibNotify
       attr_reader :expire_time

       def initialize(hash={})
         @expire_time = hash[:expire_time] || 100
       end

       def notify(options)
         system "notify-send --urgency=normal --expire-time #{@expire_time} --icon #{options[:image]} 'Ruby #{options[:title]}' '#{options[:message]}'"
       end

     end
   end
end
