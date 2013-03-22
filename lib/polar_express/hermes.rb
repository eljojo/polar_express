module PolarExpress
  module Hermes
    class Tracker
      attr_accessor :number
      def initialize(number)
        @number = number
      end
      def track!
        info = ShippingInfo.new(@number)
        info.statuses = timeline
        info
      end
      private
        def tracking_form_uri
          html = Nokogiri::HTML open 'https://www.myhermes.de/wps/portal/paket/Home/privatkunden/sendungsverfolgung/'
          URI('https://www.myhermes.de' + html.css('form#shipmentTracingDTO').first['action'])
        end
        def post_tracking_page
          res = Net::HTTP.post_form(tracking_form_uri, 'shipmentID' => @number)
          res.body
        end
        def page
          @page ||= Nokogiri::HTML post_tracking_page
        end
        def timeline
          page.css("table.table_shipmentDetails tbody tr").map do |tr|
            tds = tr.css('td') 
            {
              date: DateTime.parse(tds[0].text + " " + tds[1].text),
              # city: (city = tr.css('td.location').text.strip) == '--' ? nil : city,
              status: text_to_status(status_text = tds.last.text.strip),
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
            :destination_parcel_center
          when /The shipment has been processed in the parcel center of origin/
            :origin_parcel_center
          when /The instruction data for this shipment have been provided by the sender to DHL electronically/
            :shipping_instructions_received
          when /A .+ attempt at delivery is being made/
            :new_delivery_attempt
          else
            :other
          end
        end
    end
  end
end
