class OrdersController < ApplicationController 
  # List deliveries
  def index
    @deliveries = current_courier.deliveries
    respond_with(@deliveries)
  end    
  
  def new
    begin
      puts "Booking in session: #{booking}"
      puts "current_booking: #{current_booking.inspect}"

      raise "Booking not found via session: #{booking}" if !current_booking

      delivery_offer = Delivery::Offer.create_for :booking => current_booking, :couriers => couriers_to_notify
      
      # sends delivery offer info without contact information to each courier
      couriers_to_notify.each do |id|
        p "sending deliver info to delivery channel for courier: #{id}"
        courier_channel(id).publish :delivery_offer => delivery_offer.get_initial_info
      end
      
      puts "delivery_offer: #{delivery_offer.inspect}"
      puts "booking info in session: #{session[:booking].inspect}"
      
      @delivery = Delivery.create_from delivery_offer
      @couriers_notified = couriers_to_notify
      
      puts "Delivery: #{@delivery.inspect}"
      puts "Couriers notied: #{@couriers_notified.inspect}"
      
      rescue Exception => e
        puts "deliveries#new: #{e}"
    end
  end    

  protected

  def couriers_to_notify
    couriers_selected # + courier_companies_subscribing_to_zip(current_booking.zip)
  end  

  def booking
    @booking ||= session[:booking]
  end

  def current_booking    
    @current_booking ||= Order::Booking.where(:number => booking[:number]).first
  end
  
  def couriers_selected
    @couriers_selected ||= Courier.where(:number => current_booking.selected_couriers).to_a    
  end
end