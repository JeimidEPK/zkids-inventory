require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.day, 'Update Stocks', at: '04:00') do
    `rake products_sync:start`
  end
end