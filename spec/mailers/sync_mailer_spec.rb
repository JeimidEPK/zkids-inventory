require "rails_helper"

RSpec.describe SyncMailer, :type => :mailer do
  describe "sending the results" do
    let(:mail) { SyncMailer.sync_results({}) }

    it "renders the headers" do
      expect(mail.subject).to eq("La sincronización de productos ha terminado")
      expect(mail.to).to eq([Figaro.env.admin_mail])
      expect(mail.from).to eq(["epk-sync-script@epk-shop.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match /Sincronizacion terminada/
    end
  end
end