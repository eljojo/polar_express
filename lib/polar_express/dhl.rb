# encoding: utf-8
module PolarExpress
  module DHL
    class Tracker
      attr_accessor :number
      def initialize(number)
        number.gsub!(/[^0-9]/,'')
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
          "http://nolp.dhl.de/nextt-online-public/set_identcodes.do?lang=de&idc=#{@number}"
        end
        def page
          @page ||= Nokogiri::HTML open tracking_url
        end
        def package_percentage
          page.css("#progress-#{@number}_1").text.scan(/([\d]+)/).flatten.first.to_i
        end
        def timeline
          page.css("tr#toggle-#{@number}_1 table tbody tr").map do |tr|
            if tr.css('.retoure_left').length > 0 then
              status_text = tr.css('td.retoure_right div').last.text.strip
            else
              status_text = tr.css('td.status').text.strip
            end
            {
              date: DateTime.parse(get_date(tr.css('td.overflow').text)),
              city: (city = tr.css('td.location').text.strip) == '--' ? nil : city,
              status: text_to_status(status_text),
              text: status_text
            }
          end
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
        /Die Sendung wurde abgeholt/,
        /Die Sendung wurde dem Empfänger per vereinfachter Firmenzustellung ab Zustellbasis zugestellt/,
        /Die Sendung wurde erfolgreich zugestellt/,
        /Die Überweisung des Nachnahme-Betrags an den Zahlungsempfänger ist erfolgt/,
      ],
      :destination_parcel_center => [
        /Die Sendung wurde im Ziel-Paketzentrum bearbeitet/,
        /Die Sendung wurde innerhalb des Ziel-Paketzentrums weitergeleitet/,
      ],
      :in_delivery_vehicle => [
        /Die Sendung befindet sich auf dem Weg zur PACKSTATION/,
        /Die Sendung wird zur Abholung in die Filiale (.+) gebracht/,
        /Die Sendung wurde in das Zustellfahrzeug geladen/,
        /in Auslieferung durch Kurier/,
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
      ],
      :on_hold_at_depot => [
        /Sendung nach Zustellversuch zurück in DHL Station/,
        /Sendung zur Aufbewahrung in der Station/,
      ],
      :origin_parcel_center => [
        /Die Auslands-Sendung wurde im Start-Paketzentrum bearbeitet/,
        /Die Sendung wurde im Paketzentrum bearbeitet/,
        /Die Sendung wurde im Start-Paketzentrum bearbeitet/,
      ],
      :return_shipment => [
        /Die Sendung wurde nicht abgeholt und wird zurückgesandt/,
        /Rücksendung eingeleitet/,
      ],
      :shipping_instructions_received => [
        /Die Auftragsdaten zu dieser Sendung wurden vom Absender elektronisch an DHL übermittelt/,
      ],
      :waiting_for_pickup_by_customer => [
        /Die Sendung liegt in der Filiale zur Abholung bereit/,
        /Die Sendung liegt in der PACKSTATION zur Abholung bereit/,
      ],
    }.freeze
  end
end
