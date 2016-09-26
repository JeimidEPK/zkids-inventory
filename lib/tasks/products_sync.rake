namespace :products_sync do
  desc "Inicia la Sincronizaion de productos de EPK con Shopify"
  task start: :environment do

    shopify = Services::Shopify::Sync.new
    epk = Services::Epk::Sync.new

    epk.products.each do |p|
      sku = p["Articulo"]
      shopify.update_product(sku, p["Cantidad"])
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
