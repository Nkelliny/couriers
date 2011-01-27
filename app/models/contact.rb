class Contact
  include Mongoid::Document

  embeds_one :name, :class_name => 'Person::Name'
  embeds_one :channel, :class_name => 'Contact::Channel'

  def full_name
    name.full_name
  end

  def phone
    channel.phone if channel
  end

  def email
    channel.email if channel
  end

  def for_json
    {:name => name.for_json, :email => channel.email, :phone => channel.phone}
  end

  def to_s
    %Q{name: #{name}
#{channel}
}
  end

  class << self
    def create_from city = :munich
      co = Contact.new
      co.name = Person::Name.create_from city
      co.channel = Contact::Channel.create_from city
      co      
    end
  end    
  
  # validates_presence_of :first_name, :last_name   
  # validates :email, :email => true
  
  validate do |contact|
    contact.errors.add_to_base("Contact must have a phone or an email") if contact.phone.blank? && contact.email.blank?
  end  
end
