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
              city: tr.css('td.location').text.strip,
              status: text_to_status(tr.css('td.status').text.strip)
            }
          end
        end
        def text_to_status(text)
          case text
          when 'The shipment has been successfully delivered'
            :delivered
          when "The shipment has been loaded onto the delivery vehicle"
            :in_delivery_vehicle
          when "The shipment has been processed in the destination parcel center"
            :destination_city
          when "The shipment has been processed in the parcel center of origin"
            :origin_city
          when "The instruction data for this shipment have been provided by the sender to DHL electronically"
            :shipping_instructions_received
          else
            :other
          end
        end
    end
  end
end
