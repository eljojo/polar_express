module PolarExpress  
  class Tracker
    attr_accessor :courier, :shipping_number
    def initialize(courier, shipping_number)
      @courier = PolarExpress::identify_courier(courier)
      @shipping_number = shipping_number
      @courier_tracker = Object.const_get("PolarExpress::#{@courier.to_s}::Tracker").new(@shipping_number)
    end
    def track!
      @courier_tracker.track!
    end
  end
end
