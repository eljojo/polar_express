module PolarExpress
  module DHL
    class Tracker
      attr_accessor :number
      def initialize(number)
        @number = number
      end
      def track!
        info = ShippingInfo.new(@number)
        info.percentage = package_percentage
        info.statuses   = timeline
        require 'pp' 
        pp info.statuses
        info
      end
      private
        def tracking_url
          "http://nolp.dhl.de/nextt-online-public/set_identcodes.do?lang=en&idc=#{@number}"
        end
        def page
          @page ||= Nokogiri::HTML open tracking_url
        end
        def package_percentage
          page.css("#progress-#{@number}_1").text.scan(/([\d]+)/).flatten.first.to_i
        end
        def timeline
          page.css("tr#toggle-#{@number}_1 table tbody tr").map do |tr|
            {
              date: DateTime.parse(tr.css('td.overflow').text.strip),
              city: (city = tr.css('td.location').text.strip) == '--' ? nil : city,
              status: text_to_status(status_text = tr.css('td.status').text.strip),
              text: status_text
            }
          end
        end
        # TODO: look for better status names
        def text_to_status(text)
          case text
          when /The recipient has picked up the shipment from/
            :delivered
          when /The shipment has been successfully delivered/
            :delivered
          when /The shipment is on its way to the postal retail outlet/
            :in_delivery_vehicle_to_retail_outler
          when /The shipment has been delivered for pick-up at the/
            :waiting_for_pick_up_in_retail_office
          when /The shipment has been loaded onto the delivery vehicle/
            :in_delivery_vehicle
          when /The shipment has been processed in the destination parcel center/
            :destination_distribution_center
          when /The shipment has been processed in the parcel center of origin/
            :origin_distribution_center
          when /The instruction data for this shipment have been provided by the sender to DHL electronically/
            :shipping_instructions_received
          else
            :other
          end
        end
    end
  end
end
