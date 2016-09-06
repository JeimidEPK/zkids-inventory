namespace :products_sync do
  desc "Inicia la Sincronizaion de productos de EPK con Shopify"
  task start: :environment do

    shopify = Services::Shopify::Sync.new
    epk = Services::Epk::Sync.new

    epk.products.each do |p|
      full_ref = p["Articulo"]
      sku = full_ref.split('-').take(2).join('-')
      shopify.update_product sku, p["Cantidad"]
    end
  end
end
