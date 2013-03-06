module PolarExpress
  module DHL
    class Tracker
      attr_accessor :number
      def initialize(number)
        @number = number
      end
      def track!
        info = ShippingInfo.new
        info.percentage = package_percentage
        info.status = :delivered if info.percentage == 100
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
    end
  end
end