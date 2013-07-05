require 'spec_helper'
describe PolarExpress do
 context 'Hermes' do
    before do
      @tracker = PolarExpress.new('Hermes', '71178112099170')
    end
    it "recognizes it" do
      @tracker.courier.should eq :Hermes
    end
    it "tracks it" do
      @tracker.track!.status.should eq :delivery_succeeded
    end
    it "records tracking statuses" do
      statuses = @tracker.track!.statuses
      statuses.length.should > 1
    end
    it "recognizes every status" do
      statuses = @tracker.track!.statuses
      unrecognized_statuses = statuses.select { |status| status[:status] == :other }
      pp unrecognized_statuses unless unrecognized_statuses.empty?
      unrecognized_statuses.should be_empty
    end
  end
end
