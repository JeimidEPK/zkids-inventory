module Services
  module Shopify
    class Sync

      attr_accessor :unkown_skus
      attr_accessor :up_to_date
      attr_accessor :errors
      attr_accessor :updated
      attr_accessor :variants
      attr_accessor :out_of_track

      def initialize
        api_key = Figaro.env.s_api_key
        api_password = Figaro.env.s_password
        store = Figaro.env.s_store
        shop_url = "https://#{api_key}:#{api_password}@#{store}.myshopify.com/admin"
        ShopifyAPI::Base.site = shop_url

        products = ShopifyAPI::Product.find(:all)
        @variants = products.collect { |p| p.variants }
        @variants = @variants.flatten
        @unkown_skus = []
        @up_to_date = []
        @errors = []
        @updated = []
        @out_of_track = []
      end

      def update_product(sku, new_qty, full_ref)
        variante = find_by_sku(sku)
        if variante.present?
          if variante.inventory_management.eql?("shopify")
            if variante.inventory_quantity != new_qty
              variante.inventory_quantity = new_qty.to_i
              if variante.save!
                @updated.push(full_ref)
              else
                @errors.push(full_ref)
              end
            else
              @up_to_date.push(full_ref)
            end
          else
            @out_of_track.push(full_ref)
          end
        else
          @unkown_skus.push(full_ref)
        end
      end

      private
      def find_by_sku sku
        @variants.detect { |v| v.sku.eql? sku }
      end
    end
  end
end
