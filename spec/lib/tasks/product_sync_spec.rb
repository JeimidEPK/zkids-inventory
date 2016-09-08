RSpec.describe "products_sync:start", type: :rake do
  it { is_expected.to depend_on(:environment) }

  describe "executing the code" do

    before(:each) do
      stub_request(:get, /.myshopify./).to_return(body: "{}", status: 200)
      stub_request(:any, /retail.shopepk.com/).to_return(body: "", status: 200)
      mailer = double("mailer")
      allow(mailer).to receive(:deliver_now)
      allow(SyncMailer).to receive(:sync_results).and_return(mailer)
      subject.execute
    end

    it "get the products from shopify" do
      expect(a_request(:get, /.myshopify./)).to have_been_made.once
    end

    it "get the products from epk" do
      expect(a_request(:post, /retail.shopepk.com/)).to have_been_made.once
    end

    it "sends an email with results" do
      expect(SyncMailer).to have_received(:sync_results)
    end
  end
end