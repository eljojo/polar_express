require 'spec_helper'
describe PolarExpress do
  context 'DHL' do
    before do
      @tracker = PolarExpress.new('DHL', '777707971894')
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
      @tracker.track!.statuses.first[:date].should == DateTime.new(2013, 03, 15, 17, 45)
    end
    it "handles package refusals" do
      statuses = @tracker.track!.statuses
      statuses.find { |status| status[:status] == :return_shipment }.should_not be_nil
    end
    it "only considers numbers from tracking number" do
      tracker = PolarExpress.new('DHL', '777.707971 894')
      tracker.shipping_number.should == '777707971894'
    end
  end
end
