require 'courier/individual_ext/class_methods'
require 'courier/individual_ext/api'
require 'courier/individual_ext/proxies'

class Courier
  class Individual < ::Courier
    include Mongoid::Document

    field       :courier_number,  :type => Integer
    field       :company_name,    :type => String

    embeds_one  :person

    # after_initialize :set_number

    extend  Courier::IndividualExt::ClassMethods
    include Courier::IndividualExt::Api
    include Courier::IndividualExt::Proxies
    
    def available?
      work_state == 'available'
    end
  
    def type
      'individual'
    end  

    def to_s
      %Q{
  number: #{courier_number}
  type: #{type}
  person: #{person}
  }
    end

    protected

    def counter
      Courier::Counter::Individual
    end

    def set_number    
      self.courier_number = counter.next
      super
      save
    end  
  end
end
