require 'spec_helper'
describe PolarExpress do
  context 'Gem Basics' do
    it "creates a new instance of the gem" do
      @tracker = PolarExpress.new('DHL', '1234')
      @tracker.should respond_to :shipping_number
    end
  end
end
