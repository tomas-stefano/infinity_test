require 'spec_helper'

module InfinityTest
  module Notifications
    describe LibNotify do

      it 'should possible to set the expire time' do
        LibNotify.new(:expire_time => 1200).expire_time.should equal 1200
      end

      it 'should set 500 miliseconds as default expire time' do
        LibNotify.new.expire_time.should equal 100
      end

    end
  end
end
