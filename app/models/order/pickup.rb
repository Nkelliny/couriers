class Order::Pickup
  include Mongoid::Document
  
  embedded_in :booking, :inverse_of => :pickup
  embeds_one  :contact
  embeds_one  :address
  
  field :notes, :type => String  

  # API methods
  
  def for_json
    {:address => address.get_street, :position => location.for_json, :contact => contact.for_json }
  end    

  def get_overview
    {:position => location.for_json, :address => address.get_street }
  end

  # conv. methods

  def location
    address.location
  end

  def to_s
    %Q{
contact: 
#{contact}

address: 
#{address}

notes: #{notes}
}
  end
  
  class << self 
    def create_from_params params
      pickup = self.new :notes => params[:notes]
      pickup.contact = Contact.create_from_params params[:contact]
      pickup.address = Address.create_from_params params[:address]
      pickup      
    end
    
    def create_from city = :munich
      pickup = self.new
      pickup.address = Address.create_from city
      pickup.contact = Contact.create_from city
      pickup.notes = 'Pick it up baby!'
      pickup
    end    
  end
end