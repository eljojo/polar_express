module PolarExpress  
  class Tracker
    attr_reader :courier, :shipping_number
    def initialize(courier, shipping_number)
      @courier         = PolarExpress::identify_courier(courier)
      @shipping_number = shipping_number
      @courier_tracker = Object.const_get("PolarExpress::#{@courier}::Tracker").new(@shipping_number)
    end
    def track!
      @track ||= @courier_tracker.track!
    end
  end
end
