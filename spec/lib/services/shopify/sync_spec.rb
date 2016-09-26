require 'spec_helper'

RSpec.describe "Services::Shopify::Sync" do
  describe "initializing" do
    before(:each) do
      stub_request(:get, /.myshopify./).to_return(body: "{}", status: 200)
    end

    let(:shop) { Services::Shopify::Sync.new }

    context "instances" do
      it "should has variants" do
        expect(shop.variants).not_to be_nil
      end

      it "should has unkown_skus" do
        expect(shop.unkown_skus).not_to be_nil
      end

      it "should has up_to_date" do
        expect(shop.up_to_date).not_to be_nil
      end

      it "should has errors" do
        expect(shop.errors).not_to be_nil
      end

      it "should has updated" do
        expect(shop.updated).not_to be_nil
      end

      it "should has out_of_track" do
        expect(shop.out_of_track).not_to be_nil
      end
    end

    context "methods" do
      context "update_product" do
        context "the variant does not exist" do
          before(:each) do
            shop.variants = []
          end

          it "insert the sku in unkown_skus array" do
            shop.update_product "test", 1
            expect(shop.unkown_skus).to contain_exactly("test")
          end
        end

        context "the variant exist but does not need to be updated" do
          before(:each) do
            shop.variants = [
              double("variant", :sku => "test", :inventory_quantity => 1, :inventory_management => "shopify")
            ]
          end

          it "insert the sku in up_to_date array" do
            shop.update_product "test", 1
            expect(shop.up_to_date).to contain_exactly("test")
          end
        end

        context "the variant exist and it needs to be updated" do
          before(:each) do
            variant = double("variant", :sku => "test", :inventory_quantity => 1, :inventory_management => "shopify")
            allow(variant).to receive(:inventory_quantity=)
            allow(variant).to receive(:save!).and_return(true)
            shop.variants = [ variant ]
          end

          it "insert the sku in updated array" do
            shop.update_product "test", 9
            expect(shop.updated).to contain_exactly("test")
          end
        end

        context "the variant exist, it needs to be updated but is not allowed to be updated" do
          before(:each) do
            variant = double("variant", :sku => "test", :inventory_quantity => 1, :inventory_management => "not")
            shop.variants = [ variant ]
          end

          it "insert the sku in out_of_track array" do
            shop.update_product "test", 9
            expect(shop.out_of_track).to contain_exactly("test")
          end
        end

        context "the variant exist and it needs to be updated" do
          before(:each) do
            variant = double("variant", :sku => "test", :inventory_quantity => 1, :inventory_management => "shopify")
            allow(variant).to receive(:inventory_quantity=)
            allow(variant).to receive(:save!).and_return(false)
            shop.variants = [ variant ]
          end

          it "insert the sku in errors array" do
            shop.update_product "test", 9
            expect(shop.errors).to contain_exactly("test")
          end
        end
      end
    end
  end
end
