module PolarExpress
  module GLS
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
        def tracking_url
          "https://gls-group.eu/app/service/open/rest/EU/en/rstt001?match=#{@number}&caller=witt002Scheme"
        end
        def page
          @page ||= JSON.parse(open(tracking_url).read)
        end
        def history
          @history ||= page["tuStatus"].first["history"].map do |event|
            {
              city: event['address']['city'],
              date: DateTime.parse(event['date'] + ' ' + event['time'].split(':')[0] + ':00'),
              text: event['evtDscr']
            }
          end.uniq.reverse
        end
        def timeline
          history.each_with_index.map do |event, index|
            # GLS specific logic
            next if event[:text] == 'Inbound to GLS location to document physical hand over'
            if event[:text] == 'Inbound to GLS location' and history[index-1][:text] == 'Outbound from GLS location'
              event[:text] = 'The shipment has been processed in the destination parcel center'
            end
            event[:status] = text_to_status(event[:text])
            event
          end.compact
        end
        # TODO: look for better status names
        def text_to_status(text)
          case text
          when /Delivered/
            :delivered
          when /Out for delivery on GLS vehicle/
            :in_delivery_vehicle
          when /The shipment has been processed in the destination parcel center/
            :destination_parcel_center
          when /Inbound to GLS location/
            :origin_parcel_center
          when /Outbound from GLS location/
            :in_shipment
          when /Information transmitted, no shipment available now/
            :shipping_instructions_received
          else
            :other
          end
        end
    end
  end
end
