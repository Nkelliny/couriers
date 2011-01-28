class Address
  include Mongoid::Document

  field :street,        :type => String
  field :city,          :type => String
  field :country,       :type => String
  field :country_code,  :type => String

  embeds_one  :location

  # API method

  def for_json
    {:street => street, :city => city, :country => country}
  end
  
  def get_street
    {:street => street}
  end

  # conv. method

  #  returns the string representing the address / the address
  def to_s
    %Q{#{street}
#{city}
#{country}
}
  end

  def as_string
    "#{street}, #{city}, #{country}"
  end

  def locate! point_string = nil
    point_string ||= as_string
    raise "Address can't be located without a street" if point_string.blank?
    begin             
      loc = TiramizooApp.geocoder.geocode(point_string)

      status = loc.data["Status"]
      if status
        if status["code"] == '620'
          p "Location #{point_string} couldn't be found"
          return
        end
      end

      self.location = Location.new :latitude => loc.latitude, :longitude => loc.longitude
    rescue Exception => e
      p "Locate exception from #{point_string}: #{e}"
      p "geocoder: #{GeoMap.geo_coder.instance}"
    end
    self
  end
  
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
    def create_from_point point_string
      if !point_string.blank?        
        begin             
          loc = TiramizooApp.geocoder.geocode point_string
          status = loc.data["Status"]
          if status
            if status["code"] == '620'
              p "Location #{point_string} couldn't be found"
              return create_empty
            end
          end
          address = create_address loc.address_hash
          address.location = Location.new loc.location_hash
          return address
        rescue Exception => e
          p "Locate exception from #{point_string}: #{e}"
          p "geocode location: #{loc.inspect}"
        end
      end 
      create_empty
    end

    def create_empty
      Address::Empty.new
    end

    # city => :munich
    def create_address address_options = {}
      case get_city address_options[:city] 
      when :munich
        create_germany address_options
      else
        create_canada address_options
      end
    end

    def get_city city
      return :munich if city.downcase =~ /m.*ch.*/
      :vancouver
    end

    def create_from city = :munich
      create_from_point "#{random_street city}, #{city}"
    end

    protected

    def random_street city
      streets(city).pick_one
    end
    
    def streets city = :munich
      TiramizooApp.load_streets(city)
    end 
  end

  countries_available.map(&:to_s).each do |country|
    class_eval %{
      def self.create_#{country} *args
        Address::#{country.to_s.classify}.new *args
      end
    }
  end


  protected
  
  def set_country
    self.country = get_country
  end  
end
