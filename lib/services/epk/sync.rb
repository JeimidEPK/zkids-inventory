module Services
  module Epk
    class Sync
      include HTTParty
      attr_accessor :products
      base_uri 'http://retail.shopepk.com.co:8080'

      def initialize
        options = {
          :headers => {
            "Content-Type" => "application/x-www-form-urlencoded",
            "Host" => "localhost"
          },
          :debug_output => Rails.logger
        }
        response = self.class.post('/ws_EPKServicios.asmx/getInventarioTiendaVirtualEPK', options)
        data = Hash.from_xml(response.body)
        inventario = JSON.parse data["string"]
        @products = inventario["InventarioTiendaVirtual"]
      end
    end
  end
end