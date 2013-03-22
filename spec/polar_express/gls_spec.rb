require 'spec_helper'
describe PolarExpress do
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
end
