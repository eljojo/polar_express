require 'spec_helper'
describe PolarExpress do
  context 'GLS' do
    before do
      @tracker = PolarExpress.new('GLS', '851399109947')
    end
    it "recognizes it" do
      @tracker.courier.should eq :GLS
    end
    it "tracks it" do
      @tracker.track!.status.should eq :delivery_succeeded
    end
    it "records tracking statuses" do
      statuses = @tracker.track!.statuses
      statuses.length.should > 1
    end
  end
end
