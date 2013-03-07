module PolarExpress
  class ShippingInfo
    attr_accessor :percentage, :shipping_number, :statuses
    def initialize(number = nil)
      @shipping_number = number
      @statuses = []
    end
    def status
      statuses.last[:status] if statuses.length > 0
    end
    def last_event_at
      statuses.last[:date] if statuses.length > 0
    end
    def last_event_city
      statuses.last[:city] if statuses.length > 0
    end
  end
end
