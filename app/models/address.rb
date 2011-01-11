class Address
  include Mongoid::Document

  field :street,    :type => String
  field :city,      :type => String
  field :country,   :type => String
  
  validates_presence_of :street, :city, :country

  class << self
    def country name
      define_method :get_country do
        name
      end
    end

    def countries_available
      [:usa, :canada, :germany]
    end

    # create localized address based on current geolocation!? 
    def create_from_point point
      Address.new :street => extract_street(point), :city => extract_city(point), :zip => extract_zip(point)
    end

    # Use Geolocation service here!!!

    def extract_street address
      'Mullerstrasse 34'
    end

    def extract_zip address
      '80469'
    end

    def extract_city address
      'Munich'
    end
  end

  countries_available.map(&:to_s).each do |country|
    class_eval %{
      def create_#{country} *args
        Address::#{country.classify}.create! *args
      end        
    }
  end

  protected
  
  def set_country
    self.country = get_country
  end  
end