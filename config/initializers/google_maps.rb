module GeoMap
  class ServiceAdapter
    attr_reader :geocoder

    def geo_coder
      raise 'method #geo_coder must be implemented by adapter subclass'
    end 

    def geocode location_str
      raise 'method #geocode must be implemented by adapter subclass'
    end

    def reverse_geocode latitude, longitude
      raise 'method #reverse_geocode should be implemented by adapter subclass'
    end          
  end
  
  class GraticuleAdapter    
    def initialize service_name = :google
      @geo_coder ||= Graticule.service(service_name).new google_key
    end
      
    def geocode location_str
      geo_coder.locate location_str
    end
  end

  class GeocodeAdapter
    def initialize service_name = :google
      @geo_coder ||= Geocode.new_geocoder service_name, {:google_api_key => google_key}
    end
      
    def geocode location_str
      geo_coder.geocode location_str
    end

    def reverse_geocode latitude, longitude
      geo_coder.reverse_geocode "#{latitude}, #{longitude}"
    end      
  end

  
  class << self    
    def env 
      ENV['HEROKU_SITE'] || Rails.env.downcase || 'development'
    end
  
    def config
      @config ||= YAML.load_file("#{Rails.root}/config/google_map.yml")[env]
    end

    def google_key
      config['google_key'] 
    end

    def geo_coder type = :geocode, service_name = :google
      "#{type.classify}Adapter".constantize.new service_name
    end 
    
    def geocode location_str
      geo_coder.geocode location_str
    end    
  end
end

