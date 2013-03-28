# encoding: utf-8
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
        pp info.statuses
        info
      end
      private
        def tracking_url
          "https://gls-group.eu/app/service/open/rest/EU/de/rstt001?match=#{@number}&caller=witt002Scheme"
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
            #next if event[:text] == 'Inbound to GLS location to document physical hand over'
            event[:status] = text_to_status(event[:text])
            event
          end.compact
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
        /Ankunft im GLS Depot/,
        /Ankunft im GLS Depot \(Ausland\)/,
        /Ankunft im GLS Depot \(Großkunde\)/,
        /Ankunft im GLS Depot \(HUB\)/,
        /Ankunft im GLS Depot \(Regionalumschlag\)/,
        /Ankunft im GLS Depot Business-Small Parcel Sortierung/,
        /Ankunft im GLS Depot Grosskunden Checker/,
        /Ankunft im GLS Depot Label nicht lesbar/,
        /Ankunft im GLS Depot manuelle Sortierung/,
        /Inbound to GLS location manually sorted/,
        /Inbound to GLS location sorted as Business-Small Parcel/,
      ],
      :cancelled => [
        /Daten aus dem GLS-System gelöscht/,
        /Daten aus dem GLS-System gelöscht Betrifft Benachrichtigungskarte/,
      ],
      :delivery_failed => [
        /Empfänger ist im Urlaub/,
        /Nachnahme-Sendung nicht zugestellt/,
        /Nicht zugestellt aufgrund falscher Adresse/,
        /Nicht zugestellt da keine Annahme an diesem Tag/,
        /Nicht zugestellt da Kunde nicht angetroffen/,
        /Nicht zugestellt wegen Warenannahmeschluss/,
      ],
      :delivery_succeeded	 => [
        /Zugestellt/,
      ],
      :destination_parcel_center => [
        /Ankunft im GLS Depot \(Ziel\)/,
      ],
      :in_delivery_vehicle => [
        /In Zustellung auf GLS-Fahrzeug/,
      ],
      :in_shipment	 => [
        /Abfahrt vom GLS Depot/,
        /Auslandspaket/,
        /Paketabholung/,
        /Pickup-Service Abholung erfolgt/,
        /Pickup-Service Abholung erfolgt \(direkt\)/,
        /Weitergeleitet Umverfuegt/,
      ],
      :notification_card => [
        /Empfänger kontaktiert Betrifft Benachrichtigungskarte/,
      ],
      :on_hold => [
        /Fehlleitung auf Zustellfahrzeug/,
        /Fehlleitung im GLS-System/,
        /Fehlsortierung/,
        /Paket in Klärung/,
      ],
      :on_hold_at_depot => [
        /Aufbewahrung im GLS Depot da keine Annahme an diesem Tag/,
        /Aufbewahrung im GLS Depot da Kunde nicht angetroffen/,
        /Eingelagert/,
        /Eingelagert \(Platzmangel\)/,
        /Lieferung unvollständig/,
        /Nicht in Zustellung Neuer Zustelltermin vereinbart/,
      ],
      :return_shipment => [
        /Annahme verweigert/,
        /Annahme verweigert, weil Paket beschädigt/,
        /Aufbewahrung im GLS Depot Lagerfrist im Paket Shop überschritten/,
        /Nicht zugestellt Lagerfrist im Paket Shop überschritten/,
        /Retoure: Paket ohne Inhalt/,
        /Retoure: Paket schlecht verpackt/,
        /Zum Versender retourniert/,
      ],
      :shipping_instructions_received => [
        /Ankunft im GLS Depot der avisierten Sendungsdaten/,
        /Daten übertragen, Paket noch nicht erhalten/
      ],
      :waiting_for_pickup_by_customer => [
        /Nicht in Zustellung da Selbstabholung/,
        /Zugestellt im GLS Paket Shop/,
      ],
      :new_delivery_attempt => [
        /Keine Zustellung aus Zeitmangel/,
      ],
    }.freeze
  end
end
