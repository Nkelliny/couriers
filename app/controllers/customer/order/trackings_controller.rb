class Customer
  module Order
    class TrackingsController < InheritedResources::Base
      before_filter :authenticate_user!

      # shows the current tracking info of your delivery in progress
      def show
      end
    end
  end
end