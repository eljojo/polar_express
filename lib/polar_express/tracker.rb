module PolarExpress  
  class Tracker
    attr_reader :courier, :shipping_number
    def initialize(courier, shipping_number)
      @courier         = identify_courier(courier)
      @shipping_number = shipping_number
      @courier_tracker = Object.const_get("PolarExpress::#{@courier}::Tracker").new(@shipping_number)
    end
    def track!
      @courier_tracker.track!
    end
    
    private
      # returns a courier's symbol given it's name.
      # ideally it should be much smarter, supporting company's name, etc.
      def identify_courier(name)
        case name.upcase
        when 'DHL'
          :DHL
        end
      end
  end
end
