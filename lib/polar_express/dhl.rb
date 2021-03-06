# encoding: utf-8
module PolarExpress
  module DHL
    class Tracker
      attr_accessor :number
      def initialize(shipment_number)
        @number = shipment_number.dup.gsub(/[^A-Za-z0-9]/,'')
      end
      def track!
        info = ShippingInfo.new(@number)
        info.percentage = package_percentage
        info.statuses   = timeline
        info
      end
      private
        def tracking_url
          "http://nolp.dhl.de/nextt-online-public/set_identcodes.do?lang=de&idc=#{@number}"
        end
        def page
          return @page if @page
          uri = URI.parse(tracking_url)
          conn = Net::HTTP.new(uri.hostname, uri.port)
          resp, data = conn.post('/nextt-online-public/changeLanguage', 'lng=de', {})
          resp, data = conn.get(uri.request_uri, "Cookie" => resp.response['set-cookie'])
          @page ||= Nokogiri::HTML(resp.body)
        end
        def package_percentage
          page.css("#progress-#{@number}_1").text.scan(/([\d]+)/).flatten.first.to_i
        end
        def timeline
          page.css("#collapse-events-#{@number}_1 table tbody tr").map do |tr|
            # if tr.css('.retoure_left').length > 0 then
            #   status_text = tr.css('td.retoure_right div').last.text.strip
            # else
            tds = tr.css('td')
            status_text = tds.last.text.strip
            # end
            next if status_text == '--'
            {
              date: DateTime.parse(get_date(tds.first.text)),
              city: (city = tds[1].text.strip) == '--' ? nil : city,
              status: text_to_status(status_text),
              text: status_text,
              date_text: get_date(tds.first.text)
            }
          end.compact
        end
        def text_to_status(text)
          match = Statuses.find do |status, regexes|
            regexes.find { |regex| text =~ regex }
          end
          (match && match.first) || :other
        end
        def get_date(str)
          str.scan(/[\d]{1,2}\.[\d]{1,2}\.[\d]{4} [\d]{1,2}:[\d]{1,2}/).flatten.first
        end
    end
    Statuses = {
      :delivery_failed => [
        /Aufgrund eines Adressfehlers konnte die Sendung nicht zugestellt werden/,
        /Aus unvorhersehbaren Gründen konnte die Sendung nicht zugestellt werden/,
        /Der Empfänger wurde nicht angetroffen. Die Sendung konnte nicht zugestellt werden und wird gelagert. Der Empfänger wurde benachrichtigt/,
        /Die Sendung konnte heute nicht zugestellt werden/,
        /Die Sendung konnte nicht zugestellt werden, der Empfänger wurde benachrichtigt/,
        /Empfangsadresse bei Zustellversuch geschlossen/,
        /Erfolgloser Zustellversuch, Empfänger nicht zu Hause/,
        /Zustellung in Packstation nicht möglich/,
      ],
      :delivery_succeeded => [
        /Der Empfänger hat die Sendung aus der PACKSTATION abgeholt/,
        /Der Empfänger hat die Sendung in der Filiale abgeholt/,
        /Die Sendung wurde dem Empfänger per vereinfachter Firmenzustellung ab Zustellbasis zugestellt/,
        /Die Sendung wurde erfolgreich zugestellt/,
        /Die Überweisung des Nachnahme-Betrags an den Zahlungsempfänger ist erfolgt/,
        /The shipment has been successfully delivered/
      ],
      :destination_parcel_center => [
        /Die Sendung wurde im Ziel-Paketzentrum bearbeitet/,
        /Die Sendung wurde innerhalb des Ziel-Paketzentrums weitergeleitet/,
        /Die Retouren-Sendung wurde im Ziel-Paketzentrum bearbeitet/,
        /The shipment has been processed in the destination parcel center/
      ],
      :in_delivery_vehicle => [
        /Die Sendung befindet sich auf dem Weg zur PACKSTATION/,
        /Die Sendung wird zur Abholung in die Filiale (.+) gebracht/,
        /Die Sendung wurde in das Zustellfahrzeug geladen/,
        /in Auslieferung durch Kurier/,
        /The shipment has been loaded onto the delivery vehicle/
      ],
      :in_shipment => [
        /Die Auslandssendung wurde im Export-Paketzentrum bearbeitet/,
        /Die Sendung aus dem Ausland ist im Import-Paketzentrum eingetroffen/,
        /Die Sendung hat das Import-Paketzentrum im Zielland verlassen/,
        /Die Sendung ist im Zielland eingetroffen/,
        /Die Sendung wird ins Zielland transportiert und dort an die Zustellorganisation (.+) übergeben/,
        /Die Sendung wird ins Zielland transportiert und dort an die Zustellorganisation übergeben/,
        /Die Sendung wird ins Zielland transportiert/,
        /Die Sendung wird zur Verzollung im Zielland vorbereitet/,
        /Die Sendung wurde dem Empfänger per vereinfachter Firmenzustellung ab Paketzentrum zugestellt/,
        /Die Sendung wurde vom Absender in der Filiale eingeliefert/,
        /Geplant für Zustellung/,
        /Sendung hat den Abholstandort verlassen/,
        /Sendung hat die Umschlagbasis verlassen/,
        /Sendung ist im Zustellstandort eingegangen/,
        /Sendung ist in den Abholstandort eingegangen/,
        /Sendung ist in der Umschlagbasis eingegangen/,
        /Sendung wurde weiter bearbeitet/,
        /Verzollung abgeschlossen/,
        /Die Sendung wurde abgeholt/,
      ],
      :new_delivery_attempt => [
        /Es erfolgt ein 2. Zustellversuch/,
      ],
      :on_hold => [
        /Die für die Auslieferung der Sendung erforderlichen Daten liegen nicht vor. Die Sendung wird zurückgestellt/,
        /Die Sendung wird vorübergehend bis zur Zustellung in der Zustellbasis gelagert/,
        /Die Sendung wurde beschädigt und wird zur Nachverpackung in das Paketzentrum zurückgesandt/,
        /Die Sendung wurde fehlgeleitet und konnte nicht zugestellt werden. Die Sendung wird umadressiert und an den Empfänger weitergeleitet/,
        /Die Sendung wurde zurückgestellt. Die Zustellung erfolgt voraussichtlich am nächsten Werktag/,
        /Nicht durch DHL beeinflussbare Verzögerung in der Verzollung/,
        /Die Sendung wurde im Paketzentrum manuell nachbearbeitet/
      ],
      :on_hold_at_depot => [
        /Sendung nach Zustellversuch zurück in DHL Station/,
        /Sendung zur Aufbewahrung in der Station/,
      ],
      :origin_parcel_center => [
        /Die Auslands-Sendung wurde im Start-Paketzentrum bearbeitet/,
        /Die Sendung wurde im Paketzentrum bearbeitet/,
        /Die Sendung wurde im Start-Paketzentrum bearbeitet/,
        /Die Retouren-Sendung wurde im Start-Paketzentrum bearbeitet/,
        /The shipment has been processed in the parcel center of origin/
      ],
      :return_shipment => [
        /Die Sendung wurde nicht abgeholt und wird zurückgesandt/,
        /Rücksendung eingeleitet/,
      ],
      :shipping_instructions_received => [
        /Die Auftragsdaten zu dieser Sendung wurden vom Absender elektronisch an DHL übermittelt/,
        /The instruction data for this shipment have been provided by the sender to DHL electronically/
      ],
      :waiting_for_pickup_by_customer => [
        /Die Sendung liegt in der Filiale zur Abholung bereit/,
        /Die Sendung liegt in der PACKSTATION zur Abholung bereit/,
      ],
    }.freeze
  end
end
