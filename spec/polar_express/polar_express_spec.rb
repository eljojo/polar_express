require 'spec_helper'
describe PolarExpress do
  context 'Gem Basics' do
    it "creates a new instance of the gem" do
      @tracker = PolarExpress.new('DHL', '017219678663')
      @tracker.shipping_number.should == '017219678663'
    end
  end
  context 'DHL' do
    before do
      @tracker = PolarExpress.new('DHL', '017219678663')
    end
    it "recognizes DHL" do
      @tracker.courier.should eq :DHL
    end
    it "tracks DHL" do
      info = @tracker.track!
      info.status.should eq :delivered
    end
  end
end