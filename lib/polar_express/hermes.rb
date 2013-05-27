# encoding: utf-8
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
        # TODO: implement cities
        def timeline
          page.css("table.table_shipmentDetails tbody tr").map do |tr|
            tds = tr.css('td')
            status_text = tds.last.text.strip
            {
              date: DateTime.parse(tds[0].text + " " + tds[1].text),
              city: nil,
              status: text_to_status(status_text),
              text: status_text,
              date_text: tds[0].text + " " + tds[1].text
            }
          end.reverse
        end
        def text_to_status(text)
          match = Statuses.find do |status, regexes|
            regexes.find { |regex| text =~ regex }
          end
          (match && match.first) || :other
        end
    end

    Statuses = {
      :at_distribution_hub => [
        /Die Sendung wurde im Hermes (.+) sortiert/,
      ],
      :delivery_failed => [
        /Bitte seien Sie uns bei der Adressklärung behilflich/,
        /Der zu kassierende Betrag EUR (.+) lag beim Zustellversuch nicht vor/,
        /Die angegebene Anschrift konnte nicht gefunden werden/,
        /Die Annahme der Sendung wurde verweigert/,
      ],
      :delivery_succeeded => [
        /Die Sendung wurde zugestellt/,
      ],
      :return_succeeded => [
        /Die Sendung ist beim Versender eingegangen/
      ],
      :destination_parcel_center => [
          /Die Sendung (wurde von|ist in) der Hermes Niederlassung (.+) (übernommen|eingetroffen)/,
      ],
      :in_delivery_vehicle => [
        /Die Sendung befindet sich in der Zustellung/,
        /Die Sendung ist auf Tour gegangen/,
      ],
      :in_shipment => [
        /Die Sendung befindet sich auf dem Weg in die zuständige Hermes Niederlassung/,
        /Die Sendung hat das Lager des Versenders verlassen/,
        /Die Sendung wurde abgeholt/,
      ],
      :new_delivery_attempt => [
        /Der Empfänger wurde nicht angetroffen/,
        /Wir werden einen weiteren Zustellversuch durchführen/,
        /Der Empfänger wurde zum (1|2). Mal nicht angetroffen. Wir werden einen weiteren Zustellversuch durchführen/,
      ],
      :on_hold_at_depot => [
        /Die Sendung wird in der Hermes Niederlassung (.+) aufbewahrt/,
      ],
      :return_pickup_from_customer => [
        /Der Abholauftrag ist in der Hermes Niederlassung eingegangen/,
        /Der Abholauftrag wurde an die Hermes Logistik Gruppe übermittelt/,
        /Die Abholung wird durchgeführt/,
      ],
      :return_shipment => [
        /Die Sendung wird an den Versender zurückgeführt/,
        /Die Sendung wurde im Hermes PaketShop abgeholt und für den weiteren Transport sortiert/,
      ],
      :shipping_instructions_received => [
        /Die Sendungsdaten wurden an die Hermes Logistik Gruppe übermittelt/,
      ],
      :waiting_for_pickup_by_customer => [
        /Der Empfänger wurde zum 3. Mal nicht angetroffen/,
        /Die Sendung ist im Hermes PaketShop eingegangen/,
        /Die Sendung liegt im Hermes PaketShop zur Abholung bereit/,
        /Die Sendung wurde im Hermes PaketShop abgegeben/
      ]
    }.freeze
  end
end
