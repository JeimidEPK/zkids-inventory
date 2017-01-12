namespace :products_sync do
  desc "Inicia la Sincronizaion de productos de EPK con Shopify"
  task start: :environment do

    epk = Services::Epk::Sync.new
    # puts epk.products
    shopify = Services::Shopify::Sync.new
    stock_discount = Figaro.env.i_stock_discount.to_i

    epk.products.each do |p|
      sku = p["Articulo"]
      cantidad = Integer(p["Cantidad"])
      updated_q = cantidad > stock_discount ? cantidad - stock_discount : 0
      shopify.update_product(sku, updated_q)
    end
    results = {
      :unkown_skus => shopify.unkown_skus,
      :up_to_date => shopify.up_to_date,
      :errors => shopify.errors,
      :updated => shopify.updated,
      :out_of_track => shopify.out_of_track
    }
    SyncMailer.sync_results(results).deliver_now
  end
end
