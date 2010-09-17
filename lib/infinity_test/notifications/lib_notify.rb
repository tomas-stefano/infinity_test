module InfinityTest
   module Notifications
     class LibNotify
       
       def notify(options)
         system "notify-send --expire-time 2000 --icon #{options[:image]} 'Ruby #{options[:title]}' '#{options[:message]}'"
       end
       
     end
   end
end