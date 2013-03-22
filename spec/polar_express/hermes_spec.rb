require 'spec_helper'
describe PolarExpress do
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
