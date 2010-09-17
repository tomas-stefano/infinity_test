module InfinityTest
   module Notifications
     class LibNotify
       
       def notify(options)
         system "notify-send --expire-time 3000 --icon #{options[:image]} 'Ruby #{options[:title]}' '#{options[:message]}'"
       end
       
     end
   end
end