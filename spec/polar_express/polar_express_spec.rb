require 'spec_helper'
describe PolarExpress do
  context 'Gem Basics' do
    it "creates a new instance of the gem" do
      @tracker = PolarExpress.new('DHL', '1234')
      @tracker.should respond_to :shipping_number
    end
  end
  context 'DHL' do
    before do
      @tracker = PolarExpress.new('DHL', '777707971894')
    end
    it "recognizes it" do
      @tracker.courier.should eq :DHL
    end
    it "tracks it" do
      @tracker.track!.status.should eq :delivered
    end
    it "records tracking statuses" do
      statuses = @tracker.track!.statuses
      statuses.length.should > 1
    end
    it "tracks date correctly" do
      @tracker.track!.statuses.first[:date].should == DateTime.new(2013, 03, 15, 17, 45)
    end
  end
  context 'GLS' do
    before do
      @tracker = PolarExpress.new('GLS', '291740105981')
    end
    it "recognizes it" do
      @tracker.courier.should eq :GLS
    end
    it "tracks it" do
      @tracker.track!.status.should eq :delivered
    end
    it "records tracking statuses" do
      statuses = @tracker.track!.statuses
      statuses.length.should > 1
    end
  end
  context 'Hermes' do
    before do
      @tracker = PolarExpress.new('Hermes', '15072117753379')
    end
    it "recognizes it" do
      @tracker.courier.should eq :Hermes
    end
    it "tracks it" do
      @tracker.track!.status.should eq :delivered
    end
    it "records tracking statuses" do
      statuses = @tracker.track!.statuses
      statuses.length.should > 1
    end
  end
end
