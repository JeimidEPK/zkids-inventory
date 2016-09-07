require 'spec_helper'

RSpec.describe "Services::Epk::Sync" do
  describe "initializing" do
    before(:each) do
      stub_request(:any, /retail.shopepk.com/).to_return(body: "", status: 200)
    end

    let(:epk) { Services::Epk::Sync.new }

    context "instances" do
      it "should has products" do
        expect(epk.products).not_to be_nil
      end
    end
  end
end