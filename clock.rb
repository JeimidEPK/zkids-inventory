require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job} at: #{Time.now}"
  end

  # la hora del servidor esta 00:00 GTM, y Colombia esta GTM -5
  # es decir, que para sincronizar a las 4 AM, debemos sumar 5h mas
  every(1.day, 'Update Stocks', at: '09:00') do
    `rake products_sync:start`
  end
end
