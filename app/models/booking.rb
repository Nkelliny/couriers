class Booking
  include Mongoid::Document

  # embeds_one :pickup_address,   :class => 'Address'
  # embeds_one :dropoff_address,  :class => 'Address'
  # 
  # embeds_one :vehicle

  field :city, :type => String
  field :street, :type => String
  
  def self.create quote
    # create from a quote
  end
end
