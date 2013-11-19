require 'spec_helper'
describe PolarExpress do
  context 'DHL' do
    before do
      @tracker = PolarExpress.new('DHL', 'JJD000390003201166108')
    end
    it "recognizes it" do
      @tracker.courier.should eq :DHL
    end
    it "tracks it" do
      @tracker.track!.status.should eq :delivery_succeeded
    end
    it "records tracking statuses" do
      statuses = @tracker.track!.statuses
      statuses.length.should > 1
    end
    it "tracks date correctly" do
      @tracker.track!.statuses.first[:date].should == DateTime.new(2013, 10, 28, 14, 31)
    end
    it "handles package refusals" do
      pending "we needz shipping codes with refuzalz"
      statuses = @tracker.track!.statuses
      statuses.find { |status| status[:status] == :return_shipment }.should_not be_nil
    end
    it "recognizes every status" do
      @tracker = PolarExpress.new('DHL', 'JJD000390003201166108')
      statuses = @tracker.track!.statuses
      unrecognized_statuses = statuses.select { |status| status[:status] == :other }
      pp unrecognized_statuses unless unrecognized_statuses.empty?
      unrecognized_statuses.should be_empty
    end
    it "only considers numbers and letters from tracking number" do
      tracker = PolarExpress.new('DHL', '77A7.707971 894')
      tracker.shipping_number.should == '77A7707971894'
    end
  end
end
